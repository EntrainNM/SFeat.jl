using SFeat, DelimitedFiles, Plots

path = raw"C:\Users\hemad\Desktop\Master\Experiments\Exp3\Adult_autof0.txt"
results = readdlm(path, ' ', skipblanks=true)

println.(eachrow(results))[1]

coll = [results[:,2:3]; results[:,4:5]]

coll[(coll[:,1] .== "f"),1] .= 1
coll[(coll[:,1] .== "m"),1] .= 2

scatters = [ [((i[1] == 'f') ? 1 : 2) , i[2]] for i in eachrow(coll) ]

default(dpi=300, markersize=6, legend=:topright)
scatter(fill(0.5, length(coll[(coll[:,1] .== 1),2])),coll[(coll[:,1] .== 1),2],
            label = "Female",xticks=[0,1,2],c=:red,shape=:star5,
            title="Adult Group"
)

scatter!(fill(1.5, length(coll[(coll[:,1] .== 2),2])),coll[(coll[:,1] .== 2),2],
        label = "Male", xlim=[0,2],c=:green,
        xticks = ([0.5, 1.5], ["Female","Male"]),yticks=0:50:300, ylim=[0,maximum(coll[:,2])+10],
        shape = :star4
)

savefig(raw"C:\Users\hemad\Desktop\Master\Experiments\Exp3\autof0_Adults.png")