# Reflections on BaRley: Group 207
## Updated as of Milestone 3

### Summary of Feedback

- Overall, all of the three groups that gave us feedback overwhelmingly agreed that our app lacked appropriate documentation. It would appear that virtually [nobody understood what the purpose of our app was](https://github.com/UBC-MDS/DSCI_532_L02_group207_dashboards/issues/39), what the [graphs were trying to depict](https://github.com/UBC-MDS/DSCI_532_L02_group207_dashboards/issues/38), or even [what the dataset was about](https://github.com/UBC-MDS/DSCI_532_L02_group207_dashboards/issues/40). 
- Labels on the graphs were not easily understood and users did not even take advantage of plot interactivity because they had no idea that interactivity was even possible.
- The layout of the app was highly criticized, with some noting that it took away from more important graphs like the bar chart due to its placement. Some users did not even understand [what the point of the map was](https://github.com/UBC-MDS/DSCI_532_L02_group207_dashboards/issues/40).
- Bugs that we were not aware of were discovered by our peers. One notable issue brought to our attention was that the graphs [move into the toolbar when the screen is scrolled](https://github.com/UBC-MDS/DSCI_532_L02_group207_dashboards/issues/39).
- There exists a functionality issue in terms of [having the plots be interactive.](https://github.com/UBC-MDS/DSCI_532_L02_group207_dashboards/issues/39) Users found themselves unintentionally zooming out of the bar charts rather than scrolling down on the app itself.
- Users seemed to enjoy the toolbar and also the map plot, despite not knowing exactly what the map was trying to depict.

### Changes Made From The Past Milestone:

- As a result of the feedback, we decided to heavily prioritize adding much more documentation to the app itself. This includes adding a distinct header containing text that describes the data (where it comes from and what it contains), the purpose of the app itself and the use of the app in answering specific research questions, making the map title far more descriptive (including labelling the state as Minnesota), and finally, making the interactive features of the app far more obvious to the user (such as mousing over site locations on the map to view the location). 
- The usage of the word "All" in the selector was changed to "Both" after observing a user be confused with the meaning of the phrase word "All" in the year selector.
- We increased the size of the font on all of the graphs after users told us that labels and axis were hard to read.
- We decided to disable the interactivity of the plots to get rid of the problem of the plots preventing users from scrolling down on the app (if their mouse cursor was over a chart).

### Suggestions That Were Not Added (and why):
- It was suggested that we perhaps modify the [layout of the graphs]( https://github.com/UBC-MDS/DSCI_532_L02_group207_dashboards/issues/40) such that the map is moved away from the top since it actually is not the most important graph (when compared to the bar charts). However, there were many issues involved with the layout of the app and in particular, there were large difficulties getting the app to scale to different screen sizes (this took up a large portion of our time during Milestone 2). Thus, messing with the layout is not a trivial task and could functionally break other parts of the app. As a result, we decided to not change this in the Python version of the app, but we plan to completely change the layout and design of the second upcoming app in R.
- Another suggestion was to change the dropdown menus to sliders. This, from our viewpoint, is a personal preference and makes no functional difference to the app. We also thought that using checkboxes is less user-friendly than the current dropdown menus.
- The white lines in Altair were brought up as an issue but we have no idea why these white marks show up in the first place in Altair.
  - To improve the readability of the faceted bar graph (and to be more honest about what we are depicting) we decided to leave the bar graph unsorted since the maximum yield is highlighted in red already.
- While adding new graphs as suggested by the TA would yield huge improvements, this would be very time consuming as we would need to define new functions and then alter the layout of the app, which as mentioned before is difficult without causing formatting issues.

### Future Improvements/Known Bugs:

- An “All” option for site and variety would have been useful since it is a nuisance to select each option one by one. 
- The toolbar eats up a lot of space on the screen, and so if it was collapsable we would be able to make the graphs larger (highlighting the most important feature of our dashboard). 
- Using the map as a site selector for the plots rather than having a separate dropdown menu would have been quite nice and intuitive for the user. This would also clear clutter from the toolbar on the left while also making the map more useful (rather than just showing the location of each site).
- Adding a range slider to filter for top K yields could have been interesting.
- When the entire window is scrolled to the right, the graphs start to overlap the toolbar. This will hopefully be addressed in the R app.
- More interesting graphs would be a huge improvement. Perhaps adding a boxplot of the barley data aggregated by year to show differences between years? Or a ridgeline plot of all of the species, aggregated by year? We would need to keep the groups very general since our dataset is so small.

### Lab Session Feedback:

- Overall, the lab session revealed that our app mostly has problems with documentation. To be specific, the app does not clearly explain to the user what data it is depicting, nor does it explain how the app can be used.
- Being a "fly on the wall" really allowed us to see how much we took for granted when it came to understanding the app. We thought that the app was very straightforward and to the point, but we clearly became too familiar with the dataset itself such that we failed to document the app appropriately.            
- Many of our peers used the (very simple) app correctly but did not understand at all what the app was actually trying to accomplish. Many users were left confused as to what the graphs were showing, and what the overall use of the app was supposed to be. The map, taken out of context of the entire US, was not correctly identified by a single person because it lacked a label. Observing this over and over again really emphasized the point that our app, just by itself without the README file, was not interpretable at all.
- As a result, the majority of our efforts went to improving the documentation aspect of our app, as discussed above. These changes were very easy to fix, albeit, a lot of additional formatting and styling is required to further improve the look of the app.
- Some of the really subjective feedback, like the suggestion to switch to checkboxes rather than a dropdown menu, felt really superficial and arbitrary. This is purely a subjective decision that did not change the functionality of the app (or really improve it).
- Some of the comments were quite vague. In particular, being told that the barplots could be "side by side" is strange because they already are arranged to be side by side, technically. Having a more descriptive comment would have been way more useful since it is hard to understand what problem the user had.
- Along with improved documentation, several considerations are now being made with respect to the overall layout of the app. It is clear that the layout of the app needs to be changed to better reflect the importance of each graph. One user commented that the map seemed a bit arbitrary and not very useful. Increasing the importance of the map, perhaps by using it is as a filter for the site, would be a very obvious way to make the map more useful.
- Overall, the lab session yielded huge improvements in the documentation of the app which was a glaring problem.
