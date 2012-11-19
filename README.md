#currentwebpage

Safari と Chrome で現在表示している URL とタイトルを取得するライブラリ、コマンドラインツールです。Firefox には対応していません。異なるデスクトップスペースにあるウインドウとフルスクリーンモードは未対応です。

##コマンドラインツール
引数なしで実行すると Safari か Chrome いずれか前面にある方の URL とタイトルを改行で区切って stdout に出力します。ブラウザが見つからなかった場合やエラーが発生したら何も出力せずに終了します。github の Downloads ページにバイナリを置いておきます。

###引数
-h ヘルプを表示  
-u URL のみを取得  
-t タイトルのみを取得  
-s Safari のみを対象  
-c Chrome のみを対象  

###ツールのファイル名
コマンドラインツールを複製してファイル名を変更すればデフォルトの挙動を変えることができます。
- ファイル名に「URL」が含まれている: URL のみを取得
- ファイル名に「Title」が含まれている: タイトルのみを取得
- ファイル名に「Safari」が含まれている: Safari のみを対象
- ファイル名に「Chrome」が含まれている: Chrome のみを対象

ファイル名を変更していても引数が優先されます。

##ライブラリ

CurrentWebPage.h と CurrentWebPage.m をプロジェクトに追加すれば使えます。

###NSDictionary* CurrentWebPageCurrentInfo(NSString* prefer);
Safari または Chrome で表示しているURL とタイトルを取得する。prefer に @"safari" もしくは @"chrome" を渡すと片方のブラウザだけを対象にします。

###NSDictionary* CurrentWebPageSafariInfo();
Safari で表示しているURL とタイトルを取得します。

###NSDictionary* CurrentWebPageChromeInfo();
Chrome で表示しているURL とタイトルを取得します。

返り値はいずれも @"url" と @"title" をキーとする NSDictionary。見つからなかった場合は nil。

##License
	(The IHNDIYL)
		            I HAVE NOT DECIDED IT YET LICENSE
	                    Version 1, August 2012
	
	Copyright (C) 2012 hetima
	
	Everyone must wait for my decision about the license.
	But probably you can do almost anything you want to do.

