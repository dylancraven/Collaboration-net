Recently I've been thinking about research collaborations and how they have changed over the years. Intuitively I know that I now publish with
a lot more people in many different countries than I did during my graduate studies. Visualizing this change, I thought, would illustrate
this nicely while allowing me to familiarize myself with creating co-citation networks manually and a package, 'ggnet2'.

Before running the attached code, one needs to prepare the data set

Data wranglin' 

1. Export publications from your reference manager as a flat table (.csv or .txt), where each article is a row and columns are different characteristics associated with each publication, e.g. year of publication, authors, and journal.  

2. Cleaning author lists is tricky, as multiple delimiters (e.g., ',','and', etc.) and ways of referencing the same author (e.g., 'D. Craven', 'Craven, D', or 'D.J. Craven') are used. Given these issues, I used - gulp - LibreOffice's 'text to columns' tool to create separate columns for each author. 

From here you can follow the code in the repository and use my publication data ('Craven_pubs.csv'). As this is the first time that I have created a real, public repository, I also created a .Rmd file to annotate the entire process ("Blog_VisualizaingCollaborations.Rmd").
