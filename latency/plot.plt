set term png size 1600, 900
set output "latency.png"
set boxwidth 0.9 absolute
set style fill   solid 1.00 border lt -1
set key inside right top vertical Right noreverse noenhanced autotitles nobox
set style histogram clustered gap 1 title  offset character 0, 0, 0
set style data histograms
set xtics border in scale 0,0 nomirror rotate by -45  offset character 0, 0, 0 autojustify
set xtics  norangelimit font ",8"
set xtics   ()
set title "" 
set ytics  norangelimit font ",8"
plot 'mutual.txt' using 2:xtic(1) ti col, '' u 3 ti col , '' u 4 ti col , '' u 5 ti col , '' u 6 ti col , '' u 7 ti col , '' u 8 ti col , '' u 9 ti col

