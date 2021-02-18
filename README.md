# What Goes In
An application for habit/food ingredient tracking.

The goal of this application is to provide easy tracking for people suffering from stomach diseases. It allows users to input food 
by either typing the food name in or by scanning a barcode. At the moment text input is sent directly to the edamam API, but I am 
working to add an intermediate step that uses the GPT-3 API to break down foods into their ingredients. Barcode scanning fetches 
fairly granular results from the open food facts API. The application also allows sleep, exercise, meditation, and bowl movement 
tracking. This information is used to attempt to find correlations between behaviors, ingredients, and outcomes (bowl movements). 
There is also a community tab that shows users trending posts in subreddits relevant to their disease (ex r/ibs).

![alt-text](https://github.com/dleviminzi/what_goes_in/blob/main/README/previewFEB18.gif)
