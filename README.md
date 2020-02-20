# Shift 1 SISOP 2020 - T08
Penyelesaian Soal Shift 1 Sistem Operasi 2020\
Kelompok T08
  * I Made Dindra Setyadharma (05311840000008)
  * Muhammad Irsyad Ali (05311840000041)

---
## Table of Contents
* [Soal 1](#soal-1)
  * [Soal 1.a.](#soal-1a)
  * [Soal 1.b.](#soal-1b)
  * [Soal 1.c.](#soal-1c)
* [Soal 2](#soal-2)
  * [Soal 2.a.](#soal-2a)
  * [Soal 2.b.](#soal-2b)
  * [Soal 2.c.](#soal-2c)
  * [Soal 2.d.](#soal-2d)
* [Soal 3](#soal-3)
  * [Soal 3.a.](#soal-3a)
  * [Soal 3.b.](#soal-3b)
  * [Soal 3.c.](#soal-3c)
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

Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/blob/master/soal2/soal2.sh)

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

Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/blob/master/soal2/soal2.sh)

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

Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/blob/master/soal2/soal2_encrypt.sh)

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
  * `sudo debugfs -R 'stat <'"${inode}"'>' "${fs}" 2>/dev/null`, digunakan untuk melakukan *debugging* kepada filesystem, `-R` untuk men-*request* kepada debugfs untuk menjalankan perintah `'stat <'"${inode}"'>'`, kepada **filesystem**(`$fs`). `2>/dev/null` digunakan agar **STDERR** tidak ditampilkan.
  * Lalu di-`pipe` ke command `grep -oP 'crtime.*--\s*\K.*'`, untuk mencari **creation time** file tersebut. Namun formatnya masih berupa `date`.
  * Lalu di-`pipe` lagi ke command `cut -d ' ' -f 4` untuk mendapatkan format `hh:mm:ss`.
  * Lalu di-`pipe` lagi ke command `cut -d ':' -f 1` untuk mendapatkan jamnya dan disimpan dalam variable `$crtime`

Langkah selanjutnya adalah melakukan enkripsi pada nama file yang diinputkan berdasarkan `$crtime` yang didapat.

``` bash
filename="`echo $1 | cut -d "." -f 1`"

encrypt=`echo $filename | tr 'a-z' $(echo {a..z} | sed -r 's/ //g' | sed -r 's/(.{'$crtime'})(.*)/\2\1/') | tr 'A-Z' $(echo {A..Z} | sed -r 's/ //g' | sed -r 's/(.{'$crtime'})(.*)/\2\1/')`
```

* nama file yang didapat harus di-`cut` terlebih dahulu karena formatnya masih `$filename.txt`
* untuk mengenkripsi `$filename` tersebut, bisa menggunakan command `tr` (**translate**) pada karakter `'a-z'` ke karakter yang sudah di rotasi menggunakan *caesar cipher*
  * Untuk melakukan rotasi karakter, kita bisa menggunakan command `sed` (**stream editor**). Pertama, kita akan menge-`print` karakter dari a sampai z menggunakan perintah `echo {a..z}`.
  * Namun karakter tersebut masih terpisah dengan spasi, jadi akan di-`pipe` dengan command `sed -r 's/ //g'`.
  * Lalu dari karakter a sampai karakter ke-`$crtime` akan ditaruh dibelakang karakter z dengan command `sed -r 's/(.{'$crtime'})(.*)/\2\1/'`. Sehingga terbentuk list karakter yang sudah terotasi berdasarkan `$crtime`.
* Lalu `$filename` yang sudah di `tr` akan di `tr` kembali dengan menggunakan karakter `'A-Z'` (Kapital). Untuk prosesnya sama seperti `tr` sebelumnya.

Setelah mendapat nama file yang telah terenkripsi (`$encrypt`), akan dilakukan perubahan nama file menggunakan command `mv`

``` bash
mv $PWD/$filename.txt $PWD/$encrypt.txt
```

### Soal 2.d.

Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/blob/master/soal2/soal2_decrypt.sh)

**Deskripsi:**\
Jangan lupa untuk membuat dekripsinya supaya nama file bisa kembali

**Pembahasan:**\
Untuk poin d *script*nya sangat mirip dengan poin c. Yang membedakan adalah ketika melakukan `tr` mulai dari hasil rotasi *caesar cipher* lalu translasi ke `'a-z'`

``` bash
decrypt=`echo $filename | tr $( echo {a..z} | sed -r 's/ //g' | sed -r 's/(.{'$crtime'})(.*)/\2\1/') 'a-z' | tr $(echo {A..Z} | sed -r 's/ //g' | sed -r 's/(.{'$crtime'})(.*)/\2\1/') 'A-Z'`
```

#### ScreenShot
**Contoh Output:**\
![Output Soal 2](https://user-images.githubusercontent.com/17781660/74933307-46ad5600-5416-11ea-97fc-51ea2d456711.png)

---

## Soal 3

Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/tree/master/soal3)

**Deskripsi:**\
1 tahun telah berlalu sejak pencampakan hati Kusuma. Akankah sang pujaan hati embali ke naungan Kusuma? Memang tiada maaf bagi ELen. Tapi apa daya hati yang sudah hancur, Kusuma masih terguncang akan sikap Elen. Melihat kesedihan Kusuma, kalian mencoba menghibur Kusuma dengan mengirimkan gambar kucing.

### Soal 3.a.

Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/blob/master/soal3/soal3.sh)

**Deskripsi:**\
Maka dari itu, kalian mencoba membuat script untuk mendownload 28 gambar dari "https://loremflickr.com/320/240/cat" menggunakan command **`wget`** dan menyimpan file dangan nama "pdkt_kusuma_NO" (contoh: pdkt_kusuma_1, pdkt_kusuma_2, pdkt_kusuma_3) serta jangan lupa untuk menyimpan **log messages `wget`** kedalam sebuah file "wget.log"

**Pembahasan:**\
Untuk mendownload 28 gambar dari alamat tersebut, pertama harus mengecek apakah pada *working directory* terdapat file **"pdkt_kusuma_NO"**. Jika ada, maka script akan melanjutkan penomoran dari file terakhir. Jika tidak ada, maka akan dibuat file **"pdkt_kusuma_1"** sampai **"pdkt_kusuma_28"**. Maka pertama, kita akan mencari **NO** dari file terakhir.

``` bash
c=`ls $PWD | grep "pdkt_kusuma" | cut -d "_" -f 3 | sort -n | tail -1`
```

* listing file menggunakan command `ls` lalu akan di-`pipe` ke dalam `grep` untuk mencari seluruh file **"pdkt_kusuma"** dalam directory.
* Lalu seluruh list file dengan nama **"pdkt_kusuma"** akan di `cut` untuk mendapatkan nomornya saja.
* Lalu akan di `sort -n` berdasarkan nilai numerik secara ascending.
* Hasil yang sudah disort akan diambil nilai paling terakhir dengan command `tail -1`
* Lalu nilai tersebut akan disimpan dalam variable `$c`

Script diatas hanya bisa mendapatkan nilai jika file **"pdkt_kusuma"** sudah ada sebelumnya. Jika tidak ada, variable `$c` tidak akan menyimpan nilai apapun, sementara yang kita inginkan `$c` menyimpan nilai **0**.

``` bash
if [[ $c =~ [^0-9] ]]
then
  c=0
fi
```

Lalu akan dilakukan looping dari **`$c` + 1** sampai **`$c + 28`**

``` bash
a=`expr $c + 1`
b=`expr $c + 28`

for ((i=a;i<=b;i++))
do
  wget -a $PWD/wget.log -O $PWD/"pdkt_kusuma_$i" https://loremflickr.com/320/240/cat
done
```

pada command `wget` terdapat opsi `-a` untuk *mengappend* log dari `wget` kedalam file yang dideklarasikan, dan opsi `-O` untuk mendeklarasikan nama file output hasil `wget`

### Soal 3.b.

Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/blob/master/soal3/crontab.txt)

**Deskripsi:**\
Karena kalian gak suka ribet, kalian membuat penjadwalan untuk menjalankan script download gambar tersebut setiap 8 jam dimulai dari jam 6.05 setiap hari kecuali hari Sabtu

**Pembahasan:**\
Untuk membuat penjadwalan, dapat menggunakan `crontab -e` dengan penjadwalan sebagai berikut

```
5 6-23/8 * * 0-5 /bin/bash /home/umum/Documents/SisOpLab/SoalShiftSISOP20_modul1_T08/soal3/soal3.sh
```

* ***kolom pertama:*** `5` -> setiap menit ke-5
* ***kolom kedua:*** `6-23/8` -> setiap 8 jam dari jam 6 sampai jam 23
* ***kolom ketiga:*** `*` -> tanggal bebas
* ***kolom keempat:*** `*` -> bulan bebas
* ***kolom kelima:*** `0-5` -> setiap hari minggu sampai jumat (kecuali sabtu)

### Soal 3.c.

Source Code : [source](https://github.com/DSlite/SoalShiftSISOP20_modul1_T08/blob/master/soal3/soal3send.sh)

**Deskripsi:**\
Maka dari itu buatlah sebuah script untuk mengidentifikasi gambar yang identik dari keseluruhan gambar yang terdownload tadi. Bila terindikasi sebagai gambar yang identik, maka sisakan 1 gambar dan pindahkan sisa file identik tersebut ke dalam folder `./duplicate` dengan format filename **"duplicate_nomor"** (contoh : duplicate_200, duplicate_201). Setelah itu lakukan pemindahan semua gambar yang tersisa kedalam folder `./kenangan` dengan format filename **"kenangan_nomor"** (contoh : kenangan_252, kenangan_253). Setelah tidak ada gambar di *current directory*, maka lakukan backup seluruh log menjadi ekstensi `".log.bak"`.

**Pembahasan:**\
Untuk menentukan apakah sebuah file identik dengan yang lainya, kita dapat **Location** dari masing-masing log pada file `wget.log`. Jika terdapat kesamaan pada **Location** tersebut, maka file tersebut merupakan file **duplicate**.\
Langkah pertama yang harus dilakukan adalah mencari tahu nomor terakhir dari file **"pdkt_kusuma"**

``` bash
end=`ls $PWD | grep "pdkt_kusuma" | cut -d "_" -f 3 | sort -n | tail -1`
```

Konsep kodingan diatas sama dengan poin a. Setelah itu, kita akan mengecek apakah terdapat *directory* `./duplicate` dan `./kenangan`. Jika tidak ada, maka lakukan `mkdir` directory tersebut.

``` bash
if [[ `ls $PWD | grep "kenangan"` != "kenangan" ]]
then
  mkdir $PWD/kenangan
fi

if [[ `ls $PWD | grep "duplicate"` != "duplicate" ]]
then
  mkdir $PWD/duplicate
fi
```

Lalu kita akan mendeklarasikan variable `$arr` untuk menyimpan **Location** yang sudah dicek sebelumnya. Disini kami menggunakan *`string`* untuk memudahkan kami dalam proses pengecekan.

``` bash
arr=""
```

Lalu akan dilakukan looping dari file pertama, sampai file ke-`$end`

``` bash
for ((i=1;i<=end;i++))
do
  loc="`cat $PWD/wget.log | grep "Location:" | head -$i | tail -1 | cut -d " " -f 2`"
  isDuplicate=`echo -e $arr | awk -v loc=$loc 'BEGIN {isDuplicate=0} {if (loc==$0) isDuplicate=1} END {printf "%d", isDuplicate}'`
  if [[ $isDuplicate == 1 ]]
  then
    mv $PWD/pdkt_kusuma_$i $PWD/duplicate/duplicate_$i
  else
    arr="$arr$loc\n"
    mv $PWD/pdkt_kusuma_$i $PWD/kenangan/kenangan_$i
  fi
done
```

* `$loc` digunakan untuk menyimpan **Location** dari file saat ini.
  * Pertama akan dilakukan `cat` pada `wget.log` untuk menampilkan isinya
  * Lalu di-`pipe` ke dalam `grep` untuk mencari **Location**nya saja.
  * Karena hasil output tersebut sudah berurut dan sesuai dengan nomor file, maka akan digunakan command `head -$i` untuk mengambil `$i`-baris pertama, lalu `tail -1` untuk mengambil 1 baris terakhir.
  * Lalu di-`pipe` lagi untuk mendapatkan kolom **Location**nya saja.
* `$isDuplicate` digunakan untuk menyimpan status apakah file saat ini merupakan duplikat atau bukan.
  * Pertama `$arr` akan di `echo -e` untuk mengeluarkan isinya (beserta *newline*nya).
  * Lalu dari hasil `echo` tersebut akan di-`pipe` dengan command `awk`.
    * Dalam block **BEGIN**: menyatakan variable `isDuplicate=0`. Disini kita berasumsi bahwa file yang saat ini dicek bukan merupakan duplikat.
    * Dalam block **BODY**: akan melakukan pengecekan apakah terdapat baris yang sama dengan `$loc`, jika ada maka file merupakan duplikat. Sehingga `isDuplicate=1`.
    * Dalam block **END**: akan menge*print* nilai `isDuplicate` sehingga masuk kedalam variable `$isDuplicate` pada shell.
* Lalu akan dilakukan pengecekan apakah file yang sedak di-cek merupakan duplikat atau bukan dengan menggunakan variable `$isDuplicate`. Jika iya, maka pindahkan file ke duplicate. Jika tidak, maka tambahkan `$loc` dari file baru tersebut kedalam `$arr` dan pindahkan file ke kenangan.

Setelah itu, `wget.log` akan di-*append* kedalam `wget.log.bak`. Dan `wget.log` akan dihapus.

``` bash
cat $PWD/wget.log >> $PWD/wget.log.bak
rm $PWD/wget.log
```

#### ScreenShot
**Contoh Output:**\
![Output Soal 3](https://user-images.githubusercontent.com/17781660/74972328-11bff400-5454-11ea-869e-0f2dc23c346f.png)

**Directory kenangan:**\
![Directory Kenangan](https://user-images.githubusercontent.com/17781660/74972439-45028300-5454-11ea-9623-4c6c71b76f22.png))

**Directory duplicate:**\
![Directory Duplicate](https://user-images.githubusercontent.com/17781660/74972484-5ba8da00-5454-11ea-9fb9-7342b6bf2ab5.png)
