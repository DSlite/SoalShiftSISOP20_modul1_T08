# Shift 1 SISOP 2020 - T08
Penyelesaian Soal Shift 1 Sistem Operasi 2020\
Kelompok T08
  * I Made Dindra Setyadharma (05311840000008)
  * Muhammad Irsyad Ali (05311840000041)

---
# Table of Content
* [Soal 1](#soal-1)
  * [Soal 1.a.](#soal-1a)
  * [Soal 1.b.](#soal-1b)
  * [Soal 1.c.](#soal-1c)
* [Soal 2](#soal-2)
  * [Soal 2.a.](#soal-2a)
  * [Soal 2.b.](#soal-2b)
  * [Soal 2.c.](#soal-2c)
---

## Soal 1
Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/tree/master/soal1)

*note: didalam source terdapat shell script "[soal1tsv.sh](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/blob/master/soal1/soal1tsv.sh)" untuk mengolah data "Sample-Superstore.tsv" dan "[soal1csv.sh](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/blob/master/soal1/soal1csv.sh)" untuk mengolah data "Sample-Superstore.csv"*

**Deskripsi:**\
Whits adalah seorang mahasiswa teknik informatika. Dia mendapatkan tugas praktikum untuk membuat laporan berdasarkan data yang ada pada file "Sample-Superstore.tsv". Namun dia tidak dapat menyelesaikan tugas tersebut. Laporan yang diminta berupa:

### Soal 1.a.
**Deskripsi:**\
Tentukan wilayah bagian (region) mana yang memiliki keuntungan paling sedikit

**Pembahasan:**\
Untuk menentukan keuntungan paling sedikit, dapat menggunakan command `awk`.

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
Untuk menentukan keuntungan paling sedikit, dapat menggunakan `awk` seperti pada poin a, namun dengan sedikit perbedaan.

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

* Pada `awk` ditambahkan `-v` untuk masing-masing state, lalu akan dicari baris yang **state**nya sama dengan **state** dengan profit terkecil. Untuk konsep pada block **BODY** dan **END** sama seperti poin sebelumnya.
* Lalu kegunaan fungsi `sort` sama seperti poin sebelumnya
* Hasil `sort` akan di *pipe* ke dalam `awk` untuk mencari 10 **product** dengan **profit** terkecil. Format yang dihasilkan akan menjadi "**product**(**profit**)\n"
* Hasil command tersebut akan dimasukkan ke dalam variable `$list`. Disini tidak menggunakan `read -r` agar "**\n**" masuk ke dalam variable tersebut.
* Lalu 10 **product** dan **profit**nya akan diprint menggunakan `printf "List barang dengan profit paling sedikit antara state $state1 dan $state2:\n$list\n\n"`

#### ScreenShot
**Contoh Output:**\
![Output Soal 1](https://user-images.githubusercontent.com/17781660/74916187-ff17d180-53f7-11ea-814e-693ffe29028e.png)

---

## Soal 2

Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/tree/master/soal2)

**Deskripsi:**\
Pada suatu siang, laptop Randolf dan Afairuzr dibajak oleh seseorang dan kehilangan data-data penting. Untuk mencegah kejadian yang sama terulang kembali mereka meminta bantuan kepada Whits karena dia adalah seorang yang punya banyak ide. Whits memikirkan sebuah ide namun dia meminta bantuan kalian kembali agar ide tersebut cepat diselesaikan.

### Soal 2.a.

Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/tree/master/soal2/soal2.sh)

**Deskripsi:**\
Membuat sebuah script bash yang dapat menghasilkan password secara acak sebanyak 28 karakter yang terdapat huruf besar, huruf kecil, dan angka.

**Pembahasan:**\
Untuk men-generate password acak sebanyak 28 karakter bisa menggunakan script sebagai berikut

``` bash
read -r pass <<< "`cat /dev/urandom | tr -cd 'a-zA-Z0-9' | fold -w 28 | head -n 1`"
```

* `cat /dev/urandom` digunakan untuk men-*generate* bilangan dan karakter acak secara terus menerus
* `tr -cd 'a-zA-Z0-9'` digunakan untuk translasi ke output yang diinginkan dari hasil `cat` sebelumnya. Disini opsi `-cd` digunakan untuk menghapus inputan selain yang terdapat pada karakter `'a-zA-Z0-9'`
* Lalu akan di-`pipe` ke dalam command `fold -w 28`. Gunanya adalah untuk memberikan "**newline**" setelah 28 karakter (`-w 28`).
* Lalu hasil dari `fold` di-`pipe` lagi ke dalam command `head -n 1`. Command ini digunakan untuk mengambil 1 baris pertama input (menggunakan `-n 1`). Maka akan terbentuk 28 karakter acak yang terdiri atas huruf besar, huruf kecil, dan angka.
* 28 karakter acak tersebut lalu dimasukkan ke dalam variable `$pass`

### Soal 2.b.

Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/tree/master/soal2/soal2.sh)

**Deskripsi:**\
Password acak tersebut disimpan pada file berekstensi `.txt` dengan nama berdasarkan argumen yang diinputkan dan **Hanya berupa alphabet**.

**Pembahasan:**\
Pertama, yang harus dilakukan adalah mem-filter argumen yang diinputkan agar hanya berupa alphabet.

``` bash
read -r name <<< "`echo $1 | tr -cd 'a-zA-Z'`"
```

* `echo $1` digunakan untuk menampilkan isi dari argumen pertama (`$1`)
* Lalu hasil tersebut akan di-`pipe` kedalam `tr -cd 'a-zA-Z'` untuk menghilangkan karakter selain alphabet
* Lalu karakter yang sudah di-*filter* akan dimasukkan kedalam variable `$name`

Lalu password yang sudah di-*generate* pada poin a (`$pass`) akan dimasukkan kedalam file dengan nama file `$file.txt` menggunakan *redirection*.

``` bash
echo $pass > $PWD/$name.txt
```

### Soal 2.c.

**Deskripsi:**\
Kemudian supaya file .txt tersebut tidak mudah diketahui maka nama filenya akan di enkripsi dengan menggunakan konversi huruf (string manipulation) yang disesuaikan dengan jam(0-23) dibuatnya file tersebut dengan program terpisah menggunakan caesar cipher.

**Pembahasan:**\
Pertama, kita harus mencari kapan file yang diinputkan kedalam argumen dibuat. Setelah mencari di internet, kita dapat mengakses kapan sebuah file dibuat dengan mencari `crtime` dari sebuah file melalui `inode` file tersebut pada `filesystem` yang digunakan.

``` bash
inode=$(ls -di $PWD/"${1}" | cut -d ' ' -f 1)
fs=$(df $PWD/"${1}" | tail -1 | awk '{print $1}')
crtime=$(sudo debugfs -R 'stat <'"${inode}"'>' "${fs}" 2>/dev/null | grep -oP 'crtime.*--\s*\K.*' | cut -d ' ' -f 4 | cut -d ':' -f 1)
```

* Pertama kita mencari `$inode` dari file yang diinputkan.
  * `ls -di $PWD/"${1}"` digunakan untuk mendapatkan `inode` dari nama file yang diinputkan. `-di` digunakan untuk menampilkan `inode` dari file tersebut. Format outputnya menjadi "**inode** **nama-file**".
  * Lalu di-`pipe` ke command `cut -d ' ' -f 1`. command tersebut untuk meng-`cut` agar didapatkan `inode`nya saja. `-d` digunakan untuk mendefinisikan delimiternya, dan `-f` digunakan untuk mendefinisikan kolom yang ingin diambil.
* Lalu kita akan mencari `$fs`(**filesystem**) yang digunakan oleh file yang diinputkan.
  * `df $PWD/"${1}"` digunakan untuk mendapatkan `filesystem` yang digunakan oleh file tersebut.
  * Karena baris pertama dari command df selalu merupakan nama kolom, maka command sebelumnya di-`pipe` ke command `tail -1` untuk mendapatkan baris terakhirnya.
  * Lalu hasilnya akan di-`pipe` lagi menggunakan `awk {print $1}` untuk menampilkan nama `$fs`(**filesystem**)-nya saja.
* Lalu kita akan mencari `$crtime` dengan menggunakan `$inode` dan `$fs` yang sudah dicari sebelumnya.
