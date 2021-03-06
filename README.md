
# lombard

A tool to compare medieval price lists.


## install

```
git clone https://github.com/jmettraux/lombard.git
cd lombard
```


## usage

`bin/lombard --help`  outputs:

```
bin/lombard

  bin/lombard rota
  bin/lombard -d rota
    #==> outputs value list for "La Table Ronde"

  bin/lombard wog
  bin/lombard -d wog
    #==> outputs value list for "Wolves of God"

  bin/lombard gurps
  bin/lombard -d gurps
    #==> outputs value list for "Gurps Medieval"

  bin/lombard rota food
    #==> outputs list for "La Table Ronde" food items
  bin/lombard rota ood fabric
    #==> outputs list for "La Table Ronde" food, good, and fabric
  bin/lombard rota weap
    #==> outputs list for "La Table Ronde" weapons

  bin/lombard wog food /i/
    #==> outputs list for WOG food items with an 'i'
  bin/lombard wog "/sword|weapon/"
    #==> outputs list for WOG of swords or weapons

  bin/lombard --all "/sword|weapon/"
    #==> outputs list for all lists of swords or weapons

  bin/lombard wog -R
    #==> outputs list for WOG but without wages reference

  bin/lombard gurps -r "/sword, long/"
    #==> outputs Gurps list referenced on the price of a long sword

  bin/lombard wog -k
    #==> outputs list for WOG but sorting by category then name

  bin/lombard --all -o
  bin/lombard --all --coins
    #==> outputs list of coin systems for all lists

  bin/lombard --all -c 2400d
  bin/lombard --all --change 2400d
    #==> outputs change for 2400d for all lists
```


## links

* https://thehistoryofengland.co.uk/resource/medieval-prices-and-wages/
* https://fr.wikisource.org/wiki/Paysans_et_Ouvriers_depuis_sept_si%C3%A8cles/01
* https://mpra.ub.uni-muenchen.de/15748/1/MPRA_paper_15748.pdf
* http://medieval.ucdavis.edu/120D/Money.html :-(
* https://gurps.fandom.com/wiki/Medieval_Prices
* https://docs.google.com/document/d/0B9RK2ETMFaHcTy1uelZnWUszN1E


## LICENSE

MIT, see [LICENSE.txt](LICENSE.txt)

