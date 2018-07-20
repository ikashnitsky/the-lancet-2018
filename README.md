# Kashnitsky, I., & Schöley, J. (2018). Regional population structures at a glance. _The Lancet_, 392(10143), 209–210. [https://doi.org/10.1016/S0140-6736(18)31194-2][doi]

[![][f1]][f1]


Full text of the paper is available [here][text]. ([OSF][osf])

To replicate the map, follow the instructions in "R/master-script.R" and, of course, feel free to explore in depth the chunks of code in "R" directory. 

If you have any questions, feel free to contact me: ilya.kashnitsky@gmail.com. For the questions about [`tricolore`][tri] please contact Jonas: jschoeley@gmail.com.

Folow us on Twitter: [@ikahhnitsky][ik], [@jschoeley][js].


[f1]: https://i.imgur.com/OFFShqF.png
[doi]: https://doi.org/10.1016/S0140-6736(18)31194-2
[osf]: https://osf.io/zac5x/
[ik]: https://twitter.com/ikashnitsky
[js]: https://twitter.com/jschoeley
[tri]: https://github.com/jschoeley/tricolore

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
 - [**My PhD project -- Regional demographic convergence in Europe**][proj]
 - [Blog post on the first version of the map presented at Rostock Retreat Visualization in June 2017][post]
 - [Paper (Schöley & Willekens 2017) with the initial ideas for tricolore package][demres17]
 - [An example of ternary colorcoding used to visualize cause-of-death data][dr18]
 - [My other paper , which explores regional differences in population age structures][genus]



[genus]: https://doi.org/10.1186/s41118-017-0018-2
[arch]: https://ikashnitsky.github.io/share/1807-the-lancet-replicate/the-lancet-2018.zip
[proj]: https://osf.io/d4hjx/
[post]: https://ikashnitsky.github.io/2017/colorcoded-map/
[demres17]: https://doi.org/10.4054/DemRes.2017.36.21
[dr18]: https://github.com/ikashnitsky/demres-2018-geofacet
