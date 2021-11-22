```@meta
CurrentModule = GraphMLDatasets
```

# GraphMLDatasets

```@index
```

## Usage

```julia
graph = graphdata(Planetoid(), :cora)
train_X, train_y = traindata(Planetoid(), :cora)
test_X, test_y = testdata(Planetoid(), :cora)

# OBG datasets
graph = graphdata(OGBNProteins())
ef = edge_features(OGBNProteins())
nl = node_labels(OGBNProteins())
```

## APIs

```@docs
traindata
validdata
testdata
train_indices
valid_indices
test_indices
graphdata
rawdata
alldata
metadata
node_features
edge_features
node_labels
```

## Available datasets

### Planetoid dataset

```@docs
Planetoid
```

### Cora dataset

```@docs
Cora
```

### PPI dataset

```@docs
PPI
```

### Reddit dataset

```@docs
Reddit
```

### QM7b dataset

```@docs
QM7b
```

### OGB Node Property Prediction

#### OGBNProteins dataset

```@docs
OGBNProteins
```

#### OGBNProducts dataset

```@docs
OGBNProducts
```

#### OGBNArxiv dataset

```@docs
OGBNArxiv
```

### OGB Link Property Prediction

### OGB Graph Property Prediction
