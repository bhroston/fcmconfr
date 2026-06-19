# View FCM Network

Display an FCM in the Viewer pane as an interactive visNetwork object.
Use the shiny parameter to interact with the FCM visNetwork object and
store its output in the global environment.

The shiny app provides the following functionalities: (1) interactive
node placement, (2) the ability to toggle node labels and edge labels on
and off, (3) the ability to change node size and shape, (4) the ability
to change font size, (5) the ability to change the size of the arrowhead
on directional edges, and (6) the ability to change the curvature of
edges and the smoothing method used.

## Usage

``` r
fcm_view(
  adj_matrix = data.frame(),
  fcm_visNetwork = list(),
  shiny = FALSE,
  ...
)
```

## Arguments

- adj_matrix:

  \[`list() or data.frame()`\]  
  A single adjacency matrix (n x n) representing FCMs. An adjacency
  matrix can have conventional edge weights, IVFN edge weights or TFN
  edge weights.

- fcm_visNetwork:

  An fcm_view visNetwork object output. fcm_view accepts either an
  adj_matrix or fcm_visNetwork input but NOT both.

- shiny:

  View visNetwork output in an interactive shiny app. Allows the user to
  manipulate and save node locations and other plot characteristics.
  Outputs are saved as fcm_visNetwork objects.

- ...:

  For advanced use. Set alert_on_open = FALSE to remove the alert pop-up
  that describes how to save visNetwork outputs.

## Value

a visNetwork object that plots FCM networks in the Viewer pane; if shiny
= TRUE, plots FCM networks in a shiny app

## See also

Other utility:
[`get_fcmconfr_inferences()`](https://bhroston.github.io/fcmconfr/reference/get_fcmconfr_inferences.md)

## Examples

``` r

adj_matrix <- sample_fcms$simple_fcms$conventional_fcms[[1]]
fcm_view(adj_matrix = adj_matrix, shiny = FALSE)

{"x":{"nodes":{"id":["Guidance.Docs.for.Salt.Management","Public.Education.Programs","Salts.Added.during.Water.Treatment","Salts.Added.by.Winter.Maintenance.Activities","Ecosystem.Health","Public.Awareness.of.Reservoir.Salinization","Salinization.of.the.Reservoir"],"label":["Guidance.Docs.for.Salt.Management","Public.Education.Programs","Salts.Added.during.Water.Treatment","Salts.Added.by.Winter.Maintenance.Activities","Ecosystem.Health","Public.Awareness.of.Reservoir.Salinization","Salinization.of.the.Reservoir"],"x":[-0.06463626752482005,0.7402190381493701,-1.5,-0.8884622860369472,-0.01981595916704737,1.5,-0.3204474284427742],"y":[-1.351943623327639,-2,2,-1.049914933327261,1.723734909157319,1.406720364884634,0.144892966541367],"color":["lightgrey","lightgrey","lightgrey","lightgrey","lightgrey","lightgrey","lightgrey"],"base_color":["lightgrey","lightgrey","lightgrey","lightgrey","lightgrey","lightgrey","lightgrey"],"physics":[false,false,false,false,false,false,false]},"edges":{"from":["Guidance.Docs.for.Salt.Management","Guidance.Docs.for.Salt.Management","Public.Education.Programs","Salts.Added.by.Winter.Maintenance.Activities","Salinization.of.the.Reservoir"],"to":["Salts.Added.by.Winter.Maintenance.Activities","Salinization.of.the.Reservoir","Guidance.Docs.for.Salt.Management","Salinization.of.the.Reservoir","Ecosystem.Health"],"weight":[-0.25,-0.25,0.1,0.75,-0.75],"label":["-0.25","-0.25","0.1","0.75","-0.75"],"color":["red","red","black","black","red"],"base_color":["red","red","black","black","red"],"width":[0.5,0.5,0.2,1.5,1.5]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot","size":25,"font":{"size":14},"physics":false},"manipulation":{"enabled":false},"edges":{"physics":false,"arrows":{"to":{"enabled":true,"scaleFactor":1}},"smooth":{"enabled":true,"type":"continuous","roundness":0.4}},"physics":{"stabilization":false}},"groups":null,"width":null,"height":null,"idselection":{"enabled":false},"byselection":{"enabled":false},"main":null,"submain":null,"footer":null,"background":"rgba(0, 0, 0, 0)","igraphlayout":{"type":"square"}},"evals":[],"jsHooks":[]}
adj_matrix <- sample_fcms$simple_fcms$ivfn_fcms[[1]]
fcm_view(adj_matrix = adj_matrix, shiny = FALSE)

{"x":{"nodes":{"id":["Guidance.Docs.for.Salt.Management","Public.Education.Programs","Salts.Added.during.Water.Treatment","Salts.Added.by.Winter.Maintenance.Activities","Ecosystem.Health","Public.Awareness.of.Reservoir.Salinization","Salinization.of.the.Reservoir"],"label":["Guidance.Docs.for.Salt.Management","Public.Education.Programs","Salts.Added.during.Water.Treatment","Salts.Added.by.Winter.Maintenance.Activities","Ecosystem.Health","Public.Awareness.of.Reservoir.Salinization","Salinization.of.the.Reservoir"],"x":[-0.671419387744684,0.05291444526790001,1.5,-0.66329485883442,1.137981338977722,-1.5,0.1768777057110499],"y":[-2,2,0.9377380833021589,-0.9075825714622132,-1.441300581835984,1.032767727909067,-1.488598969215152],"color":["lightgrey","lightgrey","lightgrey","lightgrey","lightgrey","lightgrey","lightgrey"],"base_color":["lightgrey","lightgrey","lightgrey","lightgrey","lightgrey","lightgrey","lightgrey"],"physics":[false,false,false,false,false,false,false]},"edges":{"from":["Guidance.Docs.for.Salt.Management","Guidance.Docs.for.Salt.Management","Salts.Added.by.Winter.Maintenance.Activities","Salinization.of.the.Reservoir"],"to":["Salts.Added.by.Winter.Maintenance.Activities","Salinization.of.the.Reservoir","Salinization.of.the.Reservoir","Ecosystem.Health"],"weight":[-0.65,-0.65,0.35,-1],"label":["-0.65","-0.65","0.35","-1"],"color":["red","red","black","red"],"base_color":["red","red","black","red"],"width":[1.3,1.3,0.7,2]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot","size":25,"font":{"size":14},"physics":false},"manipulation":{"enabled":false},"edges":{"physics":false,"arrows":{"to":{"enabled":true,"scaleFactor":1}},"smooth":{"enabled":true,"type":"continuous","roundness":0.4}},"physics":{"stabilization":false}},"groups":null,"width":null,"height":null,"idselection":{"enabled":false},"byselection":{"enabled":false},"main":null,"submain":null,"footer":null,"background":"rgba(0, 0, 0, 0)","igraphlayout":{"type":"square"}},"evals":[],"jsHooks":[]}
adj_matrix <- sample_fcms$simple_fcms$tfn_fcms[[1]]
fcm_view(adj_matrix = adj_matrix, shiny = FALSE)

{"x":{"nodes":{"id":["Guidance.Docs.for.Salt.Management","Public.Education.Programs","Salts.Added.during.Water.Treatment","Salts.Added.by.Winter.Maintenance.Activities","Ecosystem.Health","Public.Awareness.of.Reservoir.Salinization","Salinization.of.the.Reservoir"],"label":["Guidance.Docs.for.Salt.Management","Public.Education.Programs","Salts.Added.during.Water.Treatment","Salts.Added.by.Winter.Maintenance.Activities","Ecosystem.Health","Public.Awareness.of.Reservoir.Salinization","Salinization.of.the.Reservoir"],"x":[-0.6599630182168919,0.05274238052986868,1.5,-0.7383136848536006,1.120455159183802,-1.5,0.1467303047793032],"y":[-2,2,0.9396421770638459,-0.9314784858503644,-1.37378170356698,1.077443639351686,-1.41554830628032],"color":["lightgrey","lightgrey","lightgrey","lightgrey","lightgrey","lightgrey","lightgrey"],"base_color":["lightgrey","lightgrey","lightgrey","lightgrey","lightgrey","lightgrey","lightgrey"],"physics":[false,false,false,false,false,false,false]},"edges":{"from":["Guidance.Docs.for.Salt.Management","Guidance.Docs.for.Salt.Management","Salts.Added.by.Winter.Maintenance.Activities","Salinization.of.the.Reservoir"],"to":["Salts.Added.by.Winter.Maintenance.Activities","Salinization.of.the.Reservoir","Salinization.of.the.Reservoir","Ecosystem.Health"],"weight":[-0.65,-0.65,0.35,-1],"label":["-0.65","-0.65","0.35","-1"],"color":["red","red","black","red"],"base_color":["red","red","black","red"],"width":[1.3,1.3,0.7,2]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot","size":25,"font":{"size":14},"physics":false},"manipulation":{"enabled":false},"edges":{"physics":false,"arrows":{"to":{"enabled":true,"scaleFactor":1}},"smooth":{"enabled":true,"type":"continuous","roundness":0.4}},"physics":{"stabilization":false}},"groups":null,"width":null,"height":null,"idselection":{"enabled":false},"byselection":{"enabled":false},"main":null,"submain":null,"footer":null,"background":"rgba(0, 0, 0, 0)","igraphlayout":{"type":"square"}},"evals":[],"jsHooks":[]}
```
