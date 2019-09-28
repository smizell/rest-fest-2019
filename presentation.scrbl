#lang scribble/manual

@title[#:version ""]{A Look at Racket}
@author{Stephen Mizell}

@section{About Me}

@image["promo.png" #:scale 0.4]

@itemlist[@item{Twitter: @hyperlink["https://twitter.com/Stephen_Mizell" "@Stephen_Mizell"]}
          @item{GitHub: @hyperlink["https://githu.com/smizell" "@smizell"]}
          @item{Writing: @hyperlink["https://smizell.me" "https://smizell.me"]}]

@section{Goals of This Talk}

@itemlist[@item{Share something fun}
          @item{Share a tool for teaching others how to design programs}
          @item{Share a tool for creating new languages}
          @item{Share a world to spark other ideas}]

@section{About Racket}

Racket is a general-purpose programming language as well as the world’s first ecosystem for
language-oriented programming. Make your dream language, or use one of the dozens already available.

@itemlist[@item{Cross Platform}
          @item{IDE included}
          @item{Teaching Environment}
          @item{Language Oriented Programming}]

Time for a brief introduction to the code itself.

@section{About this Document}

It's written in Scribble, which is a language created in Racket. Look, I'll add some code:

@(require pict)

This picture is generated from code:
@(colorize (filled-rectangle 40 40) "green")

I can also generate a PDF of this document.

@section{Links}

@itemlist[@item{@hyperlink["https://racket-lang.org/" "Racket Lang Site"]}
          @item{@hyperlink["https://docs.racket-lang.org/pollen/" "Pollen"]}
          @item{@hyperlink["https://beautifulracket.com/" "Beautiful Racket"]}          
          @item{@hyperlink["https://htdp.org/" "How to Design Programs"]}]


