---
layout: post
title: "Как я перенёс фотоархив с работы домой"
date: 2015-06-23 16:19:10 +0300
comments: true
categories: 
published: true
---
В общем, проблема переноса фотоархива с работы домой так окончательного решения и не находила. GoodSync отказался работать после истечения триального периода, я только зря потратил время на изучение. 

С некоторым усилием я развернул дома FTP-cервер, примечательно, что я использовал сервер, встроенный в Windows 7. С нетбука под Убунту на работе через офисный wifi я смог приконнектиться и даже скопировать файлик командой cp. Но мне надо было копировать много файлов и папок. Из рассмотренных программ: 

- gFTP работает нормально, но спотыкается об уже существующие файлы и папки
- Double Commander неправильно отображает имена папок на удалённой стороне,и самое главное, после потери соединения не может переподключиться и его приходится перезапускать, а запускается он только из командной строки, в меню он не добавился.
- Midnight Commander вообще не работает, или я чего-то не понял. На вид полное убожество, разбираться желания не возникло.

В общем, я прикинул так и этак, и сам написал программку для копировния на Ruby. Собственно, это первый осмысленный код, что я написал на Руби. Программка умеет копировать файлы по FTP, перебирая вложенные папки и копируя их структуру. Уже существующие файлы и папки пропускаются (достаточно совпадения имени).

в файле **copy_ftp_f.rb**

```ruby
require 'net/ftp'
class FTPConn < Net::FTP
	def initialize
		@ftpc=Net::FTP.new('xxx.xxx.xxx.xxx') #IP-адрес
		@ftpc.login('username','password')
	end
	def ftpConn
		@ftpc
	end	
	def closeFtpConn
		@ftpc.close
	end	
end	

class CopyFTP
	def initialize(pftp, pfrom, pto)
		@s1,@s2=pfrom,pto
		#puts '@s1='+@s1
		#puts '@s2='+@s2
		#puts '@s2(Basename)='+File.basename(@s2)
		@ftp=pftp
	end

	def copyFolder
		#puts @ftp.nlst()
		@fi=@ftp.nlst()
		if @fi.index(File.basename(@s2))
			puts 'FTP: trying to enter directory '+@s2
			fff=@ftp.chdir(File.basename(@s2))
    		puts 'Directory '+@s2+ ' exists.'
		else
			@ftp.mkdir(File.basename(@s2))
    		puts 'Directory '+@s2+ ' created.'
    		@ftp.chdir(File.basename(@s2))
		end	
		
		@fi=@ftp.nlst()
		#puts @fi
		Dir.glob(@s1+'/*') do |x|
			if File.file?(x)
				print 'Copy file '+File.basename(x)+'...' 
				if not @fi.index(File.basename(x))
					@ftp.putbinaryfile(x)
    				puts 'copied'
				else 
					puts 'already exists!'
				end
			else
				puts 'Entering directory '+x
				z=CopyFTP.new(@ftp, @s1+'/'+File.basename(x), @s2+'/'+File.basename(x))
				z.copyFolder
			end	
		end 
		@ftp.chdir('..')
	end	
end
```

в файле **copy_home.rb**

```ruby
require './copy_ftp_f.rb'
f=FTPConn.new
fc=f.ftpConn
p=CopyFTP.new(fc, ARGV[0],ARGV[1])
p.copyFolder
f.closeFtpConn
```
Для запуска из командной строки

```ruby
ruby copy_home.rb /home/maximko/from_folder to_folder
```

Работает нормально. 

Как я начинаю понимать, если под Линуксом хочешь пользоваться нормальным софтом - пиши его сам! Тут вам не винда, где всё работает с самого начала, тут вам свобода, то есть ничего готового нет.
