---
layout: post
title: "Как я уменьшаю фотографии"
date: 2015-07-16 14:03:14 +0300
comments: true
categories: 
---
Вернувшись из отпуска, я немедленно сделал то, что надо было сделать до отпуска.

1) я установил себе **exiftool**

```
sudo apt-get install libimage-exiftool-perl
```
Теперь я могу с лёгкостью выдернуть из любого RAW-файла встроенный jpeg. То же самое в Убунту можно проделать с помощью программки Shotwell, но получается отчень медленно, к тому же программка глючит.

Ещё можно было бы поставить на фотоаппарате съёмку в RAW и JPEG одновременно, но это слишком просто. 

2) я установил гем **FastImage Resize**

```
gem install fastimage_resize
```

C помощью него можно определить и изменить размеры изображения. Для работы он использует libgd (какая-то графическая библиотека вроде), так что я ещё проделал:

```
sudo apt-get install libgd2
sudo apt-get install libgd2-dev
``` 

И немедленно написал программку для пожатия:
```ruby
#rsz.rb
require 'fastimage_resize'
maxSize=600
ARGV.each{|x| print "Processing "+x+' ...'
dims=FastImage.size(Dir.pwd+'/'+x)
FastImage.resize(Dir.pwd+"/"+x,
                 if dims.first==dims.max then maxSize.to_i else 0 end,
                 if dims.first==dims.max then 0 else maxSize.to_i end,
 	             :outfile=>"/home/maximko/Octopress/source/images/2015/"+x.gsub(".","_"+maxSize.to_s+"."))
puts "Finished"
}
```

```
ruby rsz.rb IMG_20150710_144025.jpg IMG_20150712_112742.jpg IMG_20150714_125123.jpg
```

Если в имени файла встречаются нелепые символы, например, скобки, то имя файла надо брать в кавычки. Пожимает нормально, насколько я могу судить, разница с XnView не выявлена. Кроме :outfile можно ещё указать :jpeg_quality.

В Турции мне всё это пришлось бы очень кстати, я потратил немало времени на конвертацию и пожатие своих умильных фоточек. Что же, нет повода переживать, если мы когда-нибудь ещё куда-нибудь поедем, мне всё это непременно пригодится.