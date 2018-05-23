# Regional population structures at a glance

> Kashnitsky, I., & Schöley, J. (forthcoming). Regional population structures at a glance. The Lancet.

[![][f1]][f1]


Full text of the paper is available [here][text].

To replicate the map, follow the instructions in "R/master-script.R" and, of course, feel free to explore in depth the chunks of code in "R" directory. 

If you have any questions, feel free to contact me: ilya.kashnitsky@gmail.com

Folow us on Twitter: [@ikahhnitsky][ik], [@jschoeley][js].


[f1]: https://github.com/ikashnitsky/the-lancet-2018/blob/master/colorcoded-map-ikashnitsky-jschoeley.png
[text]: https://osf.io/w8hze/
[ik]: https://twitter.com/ikashnitsky
[js]: https://twitter.com/jschoeley

***


## REPLICATION. HOW TO
1. Fork this repository or [unzip the archive][arch].
2. Using RStudio open "the-lancet-2018.Rproj" file in the main project directory.
3. Run the "R/master_script.R" file. 
Wait. That's it.
The results are stored in the directory "_output".

## LOGIC OF THE PROCESS
The whole process is split into four parts, which is reflected in the structure of R scripts. First, the steps required for reproducibility are taken. Second, we define own functions. Next, all data acquisition and manipulation steps are performed.Finally, the map is built. 
The names of the scripts are quite indicative, and each script is reasonably commented. 


## SEE ALSO
 - [**My PhD project -- Regional demographic convergence in Europe**][osf]
 - [Blog post on the first version of the map presented at Rostock Retreat Visualization in June 2017][post]
 - [Paper (Schöley & Willekens 2017) with the initial ideas for tricolore package][demres17]



[doi]: https://doi.org/10.1186/s41118-017-0018-2
[arch]: https://ikashnitsky.github.io/doc/misc/the-lancet-2018.zip
[osf]: https://osf.io/d4hjx/
[post]: https://ikashnitsky.github.io/2017/colorcoded-map/
[demres17]: https://doi.org/10.4054/DemRes.2017.36.21
