for file in $(find . -name orig.dat) ; do

awk 'BEGIN{
  print "# vim:ft=plumed"
  print "# plumed 2 syntax here, automatically translated from the original input file"
  print
}{
  save[NR]=$0
  if($1=="g1<-") ing1=0
  if($1=="g2<-") {
    ing2=0
    print "co: COORDINATION GROUPA=" group1 " GROUPB=" group2 " D_0=0.30 R_0=0.10 PAIR"
  }

  if($1=="LOOP") print "WHOLEMOLECULES ENTITY0=1-"$3
  else if($1=="DISTANCE") print "d: DISTANCE ATOMS=" $3 "," $4
  else if(ing1) group1=$1 "," $2
  else if(ing2) group2=$1 "," $2
  else if($1=="COORD" && $3 != "<g1>") print "COORDINATION GROUPA=" $3 " GROUPB=" $4 " D_0=" $10 " R_0=" $12 " PAIR"
  else if($1=="LWALL") print "LOWER_WALLS ARG=co AT=2 KAPPA=500 EXP=2 EPS=1"
  else if($1=="UMBRELLA") print "RESTRAINT ARG=d KAPPA=0 AT=" $7 " SLOPE=" $9

  if($1=="g1->") ing1=1
  if($1=="g2->") ing2=1
}END{
print ""
print "ENDPLUMED"
print ""
print "# original input file with plumed 1.3 syntax follows"
print ""
for(i=1;i<=NR;i++) print save[i]
}' $file > ${file//orig.dat/plumed.dat}

done
