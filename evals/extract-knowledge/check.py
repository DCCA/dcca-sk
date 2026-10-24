#!/usr/bin/env python3
"""Mechanical faithfulness checks for an extraction against its source files.
Usage: python3 check.py <output.md> <case_dir>
- Every double-quoted span (>=3 words) must appear in a source file (normalized; fuzzy >=0.85 flagged as PARAPHRASE).
- Every number in the output must appear in a source file (else UNSOURCED-NUMBER; review by hand: some are derived, e.g. word counts).
- Reports word count. Exit code is 0; read the flags."""
import re, sys, glob, difflib, os, json
out = open(sys.argv[1]).read()
case = sys.argv[2]
src = ""
for f in glob.glob(os.path.join(case, "**", "*"), recursive=True):
    if os.path.isfile(f) and not f.endswith(("gold.md",".jpg",".png")):
        try: src += "\n" + open(f, errors="ignore").read()
        except Exception: pass
def norm(s):
    s = re.sub(r"\[\d+\]", " ", s)
    s = s.lower().replace("\u2019","'").replace("\u201c",'"').replace("\u201d",'"')
    s = re.sub(r"\b(um|uh|you know|like|sort of|kind of)\b", " ", s)
    s = re.sub(r"[^a-z0-9%$' ]+", " ", s)
    return re.sub(r"\s+", " ", s).strip()
nsrc = norm(src)
words = nsrc.split()
flags = []
for q in re.findall(r'"([^"\n]{1,400})"', out.replace("\u201c",'"').replace("\u201d",'"')):
    nq = norm(q)
    if len(nq.split()) < 3: continue
    if nq in nsrc: continue
    n = len(nq.split()); best = 0
    qw = set(nq.split()[:3])
    for i in [j for j,w in enumerate(words) if w in qw]:
        r = difflib.SequenceMatcher(None, nq, " ".join(words[i:i+n])).ratio()
        if r > best: best = r
        if best > 0.97: break
    flags.append(("PARAPHRASED-QUOTE" if best >= 0.8 else "QUOTE-NOT-IN-SOURCE", round(best,2), q[:90]))
for m in set(re.findall(r'(?<![\w.])\$?\d[\d,.]*%?[kKmM]?', out)):
    raw = m.rstrip('.,')
    core = raw.replace('$','').replace(',','').rstrip('%kKmM')
    if not core or core in ('1','2','3','4','5','6','7'):  # list numbering / small counts: review manually
        continue
    if core in src.replace(',','') or raw in src: continue
    flags.append(("UNSOURCED-NUMBER", None, raw))
body = "\n".join(l for l in out.splitlines() if not l.startswith("# "))
wc = len(re.sub(r"[#*`>|-]", " ", body).split())
print(json.dumps({"file": sys.argv[1], "words": wc, "flags": flags}, indent=1))
