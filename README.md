# Shift 1 SISOP 2020 - T08
Penyelesaian Soal Shift 1 Sistem Operasi 2020\
Kelompok T08
  * I Made Dindra Setyadharma (05311840000008)
  * Muhammad Irsyad Ali (05311840000041)

## Soal 1
Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/tree/master/soal1)

*note: didalam source terdapat shell script "[soal1tsv.sh](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/blob/master/soal1/soal1tsv.sh)" untuk mengolah data "Sample-Superstore.tsv" dan "[soal1csv.sh](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/blob/master/soal1/soal1csv.sh)" untuk mengolah data "Sample-Superstore.csv"*

**Deskripsi**:\
Whits adalah seorang mahasiswa teknik informatika. Dia mendapatkan tugas praktikum untuk membuat laporan berdasarkan data yang ada pada file "Sample-Superstore.tsv". Namun dia tidak dapat menyelesaikan tugas tersebut. Laporan yang diminta berupa:

### Soal 1.a.
**Deskripsi:**\
Tentukan wilayah bagian (region) mana yang memiliki keuntungan paling sedikit

**Pembahasan:**\
Untuk menentukan keuntungan paling sedikit, dapat menggunakan command awk. Berikut kode sumbernya

``` bash
read -r region regionprofit <<< `awk -F "\t" 'NR > 1 {seen[$13]+=$NF} END {for (i in seen) printf "%s?%f\n", i, seen[i]}' $PWD/Sample-Superstore.tsv | sort -g -t? -k2 | awk -F? 'NR < 2 {printf "%s %f ", $1, $2}'`
printf "Region dengan profit paling sedikit:\n$region($regionprofit)\n\n"
```

* Pada bagian `awk -F "\t" 'NR > 1 {seen[$13]+=$NF} END {for (i in seen) printf "%s?%f\n", i, seen[i]}' $PWD/Sample-Superstore.tsv`, akan menjalankan perintah awk dengan **"tab"** sebagai field separatornya.
  * Dalam block **BODY**: akan mengecek dari baris kedua dari `Sample-Superstore.tsv` lalu akan menambahkan jumlah dari **profit**(`$NF`) kedalam array `seen` dengan menggunakan **region**(`$13`) sebagai index dari array tersebut.
  * Dalam block **END**: akan melakukan loop untuk setiap index dari array `seen`, lalu setiap index dan nilainya akan diprint menggunakan `printf "%s?$f\n", i, seen[i]`. Format yang dihasilkan berupa "**region**?**profit**". Disini menggunakan tanda "**?**" sebagai delimiter pada perintah selanjutnya.
* Lalu dari `awk` tersebut akan di pipe ke dalam command `sort -g -t? -k2`. Dari hasil awk sebelumnya, akan dilakukan sorting, `-g` digunakan untuk nilai **numeric general**. `-t?` untuk mendefinisikan delimiter yang digunakan ("**?**"). dan `-k2` untuk memilih kolom yang ingin disortir (dalam kasus ini kolom **kedua** akan disortir secara **ascending**).
* Lalu akan di pipe lagi ke dalam `awk -F? 'NR < 2 {printf "%s %f ", $1, $2}'`. `awk` ini digunakan untuk mengambil nilai terkecil dari hasil sortir sebelumnya. Lalu diprint dengan format "**region** **profit** ".
* Setelah mendapat region dengan profit terkecil, hasil tersebut akan disimpan kedalam variable `$region` dan `$regionprofit`. disini kami menggunakan perintah \<\<\< untuk memasukkan variablenya dan `read -r` untuk membaca dari seluruh command sebelumnya. `-r` digunakan untuk meng-ignore backlash(**\\**).

### Soal 1.b.
**Deskripsi:**\
Tampilkan 2 negara bagian (state) yang memiliki keuntungan (profit) paling sedikit berdasarkan hasil poin a

**Pembahasan:**\
Untuk menentukan keuntungan paling sedikit, dapat menggunakan awk seperti pada poin a, namun dengan sedikit perbedaan. Berikut kode sumbernya

``` bash
read -r state1 state1profit state2 state2profit <<< `awk -F "\t" -v region=$region '{if (match($13, region)) seen[$11]+=$NF} END {for (i in seen) printf "%s?%f\n", i, seen[i]}' $PWD/Sample-Superstore.tsv | sort -g -t? -k2 | awk -F? 'NR < 3 {printf "%s %f ", $1, $2}'`
printf "2 State dengan profit paling sedikit dari region $region:\n$state1($state1profit)\n$state2($state2profit)\n\n"
```
