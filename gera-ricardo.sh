#!/bin/bash

touch 0000-plano.csv
rm -f ../GERADOS2/*ricardo*
cp financeiro-ricardo.csv importacao.txt
dos2unix importacao.txt
sed -i '1,4d ; /^ \t/d ; /^\t/d ; s/–/-/g' importacao.txt
sed -i 's/"\f"//' importacao.txt
sed -i 'y/áÁàÀãÃâÂéÉêÊíÍóÓõÕôÔúÚçÇ/aAaAaAaAeEeEiIoOoOoOuUcC/' importacao.txt

cat importacao.txt | tr [a-z] [A-Z]  > importacao.tmp
cp importacao.tmp importacao.txt
sed -i '/^DATA/d ; /^\t/d' importacao.txt
sed -i '/\t#N\/DISP\t/d' importacao.txt
cut -f1 importacao.txt > data.tmp
cut -f2 importacao.txt > historico1.tmp
cut -f3 importacao.txt > historico2.tmp
cut -f6 importacao.txt | sed 's/ //g' > nf.tmp
sed -i 's/\//-/g' historico*
sed -i '/^$/!s/^/NF /' nf.tmp
paste -d " " historico1.tmp historico2.tmp nf.tmp > historico.tmp
sed -i 's/  / /g' historico.tmp
cut -f7 importacao.txt > conta-d.tmp
cut -f9 importacao.txt > conta-c.tmp
cut -f8 importacao.txt > valor.tmp
sed -i 's/ //g ; s/-//' valor.tmp
sed -i 's/\.// ; s/\,/\./g' valor.tmp
cut -f4 importacao.txt > pr.tmp
sed -i 's/^ \+//' *.tmp
sed -i 's/ *$//g' *.tmp



banco=`cat quem`


####### NUMEROS
cut -d '"' -f2 0000-plano.csv > conta.tmp
cut -d '"' -f4 0000-plano.csv > numero.tmp

sed -i 's/^[ \t]*//;s/[ \t]*$//' conta.tmp numero.tmp
sed -i "s/^/correlaciona -i '\/\^/" conta.tmp
sed -i "s/$/\$\/s\/$\/@/" conta.tmp
sed -i "s/$/\/g' conta-d.tmp/" numero.tmp
paste conta.tmp numero.tmp > plano-pronto.tmp
sed -i "s/\t//g" plano-pronto.tmp
cat plano-pronto.tmp | sort | uniq > monta-numeros
chmod 775 monta-numeros
./monta-numeros
cut -d "@" -f1 conta-d.tmp > socontas.tmp
cut -d "@" -f2 conta-d.tmp > sonumeros.tmp
cp socontas.tmp conta-d.tmp


a=`cat valor.tmp`
printf "%21s\n" $a > zeros.tmp
cp zeros.tmp valor.tmp
sed -i 's/-/ /' valor.tmp

sed -i 's/^$/1419/' conta-d.tmp
a=`cat conta-d.tmp`
printf "%9s\n" $a > zeros.tmp
cp zeros.tmp conta-d.tmp

sed -i 's/^$/1419/' conta-c.tmp
a=`cat conta-c.tmp`
printf "%9s\n" $a > zeros.tmp
cp zeros.tmp conta-c.tmp

paste -d "" data.tmp data.tmp > datadata.tmp
sed -i 's/^/00000000000000J/' datadata.tmp
paste -d "" pr.tmp datadata.tmp > datadata.txt
cat datadata.txt > datadata.tmp
sed -i 's/$//' datadata.tmp

sed -i 's/$/                     /' conta-c.tmp
sed -i 's/$/000000000000.00000000000000.00000000000000.00000000000000.00/' data.tmp
paste -d "" datadata.tmp conta-d.tmp  valor.tmp conta-c.tmp data.tmp historico.tmp  | iconv -f utf-8 -t iso-8859-1 > $banco.ASIA
unix2dos $banco.ASIA
cp $banco.ASIA ../GERADOS2/$banco.ASIA.txt
rm -f *.tmp *.csv  datadata.txt importacao.ASIA  importacao.txt  monta-numeros
rm -f ../AGERAR2/*ricardo*
rm -f quem $banco.ASIA
wc -l ../GERADOS2/$banco.ASIA.txt > ../GERADOS2/$banco-numeros.tmp
lancamentos=`cat ../GERADOS2/$banco-numeros.tmp | cut -d " " -f1`
echo "Arquivo $banco gerado em `date` $lancamentos Lancamentos" >> /var/log/IMPORTACOES/gerados-b7.tmp
