#!/bin/bash
#本脚本用于可视化inef3 输出的数据
#$1为需处理的文件，$2为表格的标题，$3为表格的高，$4为表格的 高/宽
echo "正在处理文件：$1"
#开始预处理文件内容
sed -i '/^iperf3/'d $1 #删除以iperf3开头的行
sed -i '/Bandwidth$/'d $1 #删除以Bandwidth结尾的行
awk -F'MBytes' -vOFS="MBytes" '{$1="";$1=$1}1' $1 > $1.tmp #删除MBytes前面的所有东西
mv -f $1.tmp $1
rm -f $1.tmp
sed -i 's/ //g' $1 #删除所有空格
sed -i 's/MBytes//g' $1
sed -i 's/Mbits\/sec//g' $1
sed -i '/^$/d' $1
nl -n ln $1 > $1.tmp
mv -f $1.tmp $1
rm -f $1.tmp
sed -i 's/     //g' $1
sed -i 's/    //g' $1
sed -i 's/   //g' $1
sed -i 's/  //g' $1
sed -i 's/	/ /g' $1
#确定表格的宽
kuan="$3*$4" | bc
#开始生成表格
gnuplot -persist <<-EOFMarker
	set title "$2"
	set xlabel "time/s"
	set ylabel "Mbits/s"
	set grid
	set terminal pngcairo size $3,$kuan color solid linewidth 2 font "Helvetica, 30"
	set size ratio 0.25
	set output "$2.png"
	plot "$1" with linespoints
EOFMarker
echo "文件$1处理完成，已输出为$2.png"
exit