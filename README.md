# Getting_to_Philosophy
"Getting to Philosophy" is defined on wikipedia as: "Clicking on the first link in the main text of an English Wikipedia article, and then repeating the process for subsequent articles, usually leads to the Philosophy article. In February 2016, this was true for 97% of all articles in Wikipedia, an increase from 94.52% in 2011. The remaining articles lead to an article without any outgoing wikilinks, to pages that do not exist, or get stuck in loops."

https://en.wikipedia.org/wiki/Wikipedia:Getting_to_Philosophy

The program should receive a Wikipedia link as an input, go to another normal link and repeat this process until either Philosophy page is reached, or we are in an article without any outgoing Wikilinks, or stuck in a loop. This process is repeated to create the whole network of a sample size of your choice

A "normal link" is a link from the main page article, not in a box, is blue (red is for non-existing articles), not in parentheses, not italic and not a footnote. You don't have to check style tables or other fancy things, it is enough that the script works with the current Wikipedia style (for example you can use 'class' attribute in Wikipedia tags). For easy validation, please print all visited links to the standard output.
