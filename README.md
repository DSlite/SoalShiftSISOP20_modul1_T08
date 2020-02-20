# Shift 1 SISOP 2020 - T08
Penyelesaian Soal Shift 1 Sistem Operasi 2020\
Kelompok T08
  * I Made Dindra Setyadharma (05311840000008)
  * Muhammad Irsyad Ali (05311840000041)

## Soal 1
Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/tree/master/soal1)

*note: didalam source terdapat shell script "[soal1tsv.sh](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/blob/master/soal1/soal1tsv.sh)" untuk mengolah data "Sample-Superstore.tsv" dan "[soal1csv.sh](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/blob/master/soal1/soal1csv.sh)" untuk mengolah data "Sample-Superstore.csv"*

**Deskripsi:**\
Whits adalah seorang mahasiswa teknik informatika. Dia mendapatkan tugas praktikum untuk membuat laporan berdasarkan data yang ada pada file "Sample-Superstore.tsv". Namun dia tidak dapat menyelesaikan tugas tersebut. Laporan yang diminta berupa:

### Soal 1.a.
**Deskripsi:**\
Tentukan wilayah bagian (region) mana yang memiliki keuntungan paling sedikit

**Pembahasan:**\
Untuk menentukan keuntungan paling sedikit, dapat menggunakan command `awk`. Berikut kode sumbernya

``` bash
read -r region regionprofit <<< `awk -F "\t" 'NR > 1 {seen[$13]+=$NF} END {for (i in seen) printf "%s?%f\n", i, seen[i]}' $PWD/Sample-Superstore.tsv | sort -g -t? -k2 | awk -F? 'NR < 2 {printf "%s %f ", $1, $2}'`
printf "Region dengan profit paling sedikit:\n$region($regionprofit)\n\n"
```

* Pada bagian `awk -F "\t" 'NR > 1 {seen[$13]+=$NF} END {for (i in seen) printf "%s?%f\n", i, seen[i]}' $PWD/Sample-Superstore.tsv`, akan menjalankan perintah awk dengan **"tab"** sebagai field separatornya.
  * Dalam block **BODY**: akan mengecek dari baris kedua dari `Sample-Superstore.tsv` lalu akan menambahkan jumlah dari **profit**(`$NF`) kedalam array `seen` dengan menggunakan **region**(`$13`) sebagai index dari array tersebut.
  * Dalam block **END**: akan melakukan loop untuk setiap index dari array `seen`, lalu setiap index dan nilainya akan diprint menggunakan `printf "%s?$f\n", i, seen[i]`. Format yang dihasilkan berupa "**region**?**profit**\n". Disini menggunakan tanda "**?**" sebagai delimiter pada perintah selanjutnya.
* Lalu dari `awk` tersebut akan di *pipe* ke dalam command `sort -g -t? -k2`. Dari hasil awk sebelumnya, akan dilakukan sorting, `-g` digunakan untuk nilai **numeric general**. `-t?` untuk mendefinisikan delimiter yang digunakan ("**?**"). dan `-k2` untuk memilih kolom yang ingin disortir (dalam kasus ini kolom **kedua** akan disortir secara **ascending**).
* Lalu akan di *pipe* lagi ke dalam `awk -F? 'NR < 2 {printf "%s %f ", $1, $2}'`. `awk` ini digunakan untuk mengambil nilai terkecil dari hasil sortir sebelumnya. Lalu diprint dengan format "**region** **profit** ".
* Setelah mendapat region dengan profit terkecil, hasil tersebut akan disimpan kedalam variable `$region` dan `$regionprofit`. disini kami menggunakan perintah \<\<\< untuk memasukkan variablenya dan `read -r` untuk membaca dari seluruh command sebelumnya. `-r` digunakan untuk meng-ignore backlash(**\\**).
* Lalu **region** dan **profit**nya akan diprint menggunakan `printf "Region dengan profit paling sedikit:\n$region($regionprofit)\n\n"`

### Soal 1.b.
**Deskripsi:**\
Tampilkan 2 negara bagian (state) yang memiliki keuntungan (profit) paling sedikit berdasarkan hasil poin a

**Pembahasan:**\
Untuk menentukan keuntungan paling sedikit, dapat menggunakan `awk` seperti pada poin a, namun dengan sedikit perbedaan. Berikut kode sumbernya

``` bash
read -r state1 state1profit state2 state2profit <<< `awk -F "\t" -v region=$region '{if (match($13, region)) seen[$11]+=$NF} END {for (i in seen) printf "%s?%f\n", i, seen[i]}' $PWD/Sample-Superstore.tsv | sort -g -t? -k2 | awk -F? 'NR < 3 {printf "%s %f ", $1, $2}'`
printf "2 State dengan profit paling sedikit dari region $region:\n$state1($state1profit)\n$state2($state2profit)\n\n"
```

* Pada bagian `awk -F "\t" -v region=$region '{if (match($13, region)) seen[$11]+=$NF} END {for (i in seen) printf "%s?%f\n", i, seen[i]}' $PWD/Sample-Superstore.tsv`, akan menjalankan perintah awk dengan "**tab**" sebagai field separatornya. Selain itu `-v` digunakan untuk meng-set variable ***region*** (region dengan profit terkecil) kedalam awk.
  * Dalam block **BODY**: akan mengecek apakah kolom ke-`$13`(**regionnya**) sama dengan region yang didapat pada poin a. Jika sama, maka **profit**(`$NF`) dari **state** tersebut akan dijumlahkan ke dalam array `seen` dengan menggunakan **state**(`$11`) sebagai index dari array tersebut.
  * Dalam block **END**: akan melakukan loop untuk setiap index dari array `seen`, lalu setiap index dan nilainya akan diprint menggunakan `printf "%s?$f\n", i, seen[i]`. Format yang dihasilkan berupa "**state**?**profit**\n".
* Lalu dari `awk` tersebut akan di *pipe* ke dalam command `sort -g -t? -k2`. Kegunaannya sama dengan poin a, yaitu untuk mensortir berdasarkan kolom kedua(**profit**).
* Lalu akan di *pipe* lagi ke dalam `awk -F? 'NR < 3 {printf "%s %f ", $1, $2}'`. Kegunaannya sama dengan poin a, tetapi disini akan mengambil 2 nilai terkecil dari hasil sortir sebelumnya. Lalu diprint dengan format "**state** **profit** ".
* Setelah mendapat 2 state dengan region terkecil, hasil tersebut akan disimpan kedalam variable `$state1`, `$state1profit`, `$state2`, `$state2profit`. Cara memasukkannya sama dengan poin a.
* Lalu 2 **state** dan **profit**nya akan diprint menggunakan `printf "2 State dengan profit paling sedikit dari region $region:\n$state1($state1profit)\n$state2($state2profit)\n\n"`

### Soal 1.c.
**Deskripsi:**\
Tampilkan 10 produk (product name) yang memiliki keuntungan (profit) paling sedikit berdasarkan 2 negara bagian (state) hasil poin b

**Pembahasan:**\
Untuk poin c, bisa menggunakan `awk` yang mirip dengan poin b. Untuk variablenya, ditambahkan variable `$state1` dan `$state2` kedalam `awk`.

``` bash
list=`awk -F "\t" -v state1=$state1 -v state2=$state2 '{if (match ($11, state1)||match ($11, state2)) seen[$17]+=$NF} END {for (i in seen) printf "%s?%f\n", i, seen[i]}' $PWD/Sample-Superstore.tsv | sort -g -t? -k2 | awk -F? 'NR < 11 {printf "%s(%f)\n", $1, $2}'`
printf "List barang dengan profit paling sedikit antara state $state1 dan $state2:\n$list\n\n"
```

* pada `awk` ditambahkan `-v` untuk masing-masing state, lalu akan dicari baris yang **state**nya sama dengan **state** dengan profit terkecil. Untuk konsep pada block **BODY** dan **END** sama seperti poin sebelumnya.
* lalu kegunaan fungsi `sort` sama seperti poin sebelumnya
* Hasil `sort` akan di *pipe* ke dalam `awk` untuk mencari 10 **product** dengan **profit** terkecil. Format yang dihasilkan akan menjadi "**product**(**profit**)\n"
* Hasil command tersebut akan dimasukkan ke dalam variable `$list`. Disini tidak menggunakan `read -r` agar "**\n**" masuk ke dalam variable tersebut.
* Lalu 10 **product** dan **profit**nya akan diprint menggunakan `printf "List barang dengan profit paling sedikit antara state $state1 dan $state2:\n$list\n\n"`

**Contoh Output:**\
![Output Soal 1](https://user-images.githubusercontent.com/17781660/74916187-ff17d180-53f7-11ea-814e-693ffe29028e.png)

## Soal 2

Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/tree/master/soal2)

**Deskripsi:**\
Pada suatu siang, laptop Randolf dan Afairuzr dibajak oleh seseorang dan kehilangan data-data penting. Untuk mencegah kejadian yang sama terulang kembali mereka meminta bantuan kepada Whits karena dia adalah seorang yang punya banyak ide. Whits memikirkan sebuah ide namun dia meminta bantuan kalian kembali agar ide tersebut cepat diselesaikan.

### Soal 2.a.

Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/tree/master/soal2/soal2.sh)

**Deskripsi:**\
Membuat sebuah script bash yang dapat menghasilkan password secara acak sebanyak 28 karakter yang terdapat huruf besar, huruf kecil, dan angka.

**Pembahasan:**\
