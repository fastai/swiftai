# SwiftAI

Pre-alpha version of Swift for TensorFlow's high-level API, modeled after fastai. The *stable* branch works with v0.4 of [Swift for TensorFlow](https://github.com/tensorflow/swift/blob/master/Installation.md) (s4tf), and the *master* branch follows the nightlies of s4tf. To learn the details of what's in this repo, check out lessons 13 and 14 of [course.fast.ai](https://course.fast.ai). Full docs will be added here as things become more stable.

You can download and train [imagenette](https://github.com/fastai/imagenette/) by typing `swift run` at the root of this repo.

SwiftAI is built from the notebooks in `nbs/`. Once you have the notebooks working the way you want, run the `tools/export_import.ipynb` (we'll be replacing this exporter with a script soon).

Here's a walk-thru of training a model:

```swift
import SwiftAI
import TensorFlow
```

We need both SwiftAI and TensorFlow packages, since SwiftAI is designed to work *with* TensorFlow, not to *replace* TensorFlow.

```swift
let path = downloadImagenette()
```

As s4tf and SwiftAI add support for more types of models, we'll be adding lots of datasets; for now just Imagenette and MNIST are provided.

```swift
let il = ItemList(fromFolder: path, extensions: ["jpeg", "jpg"])
let sd = SplitData(il) {grandParentSplitter(fName: $0, valid: "val")}
```

We use the Swift version of the [data block API](https://docs.fast.ai/data_block.html#The-data-block-API) to grab the files we need, and split in to train and validation sets.

```swift
var procLabel = CategoryProcessor()
let sld = makeLabeledData(sd, fromFunc: parentLabeler, procLabel: &procLabel)
```

*Processors* are (potentially stateful) functions which preprocess data. In this case, `CategoryProcessor` gets a list of unique labels from the data and creates a mapping to turn labels into `Int`s.

```swift
let rawData = sld.toDataBunch(itemToTensor: pathsToTensor, labelToTensor: intsToTensor, bs: 128)
```

A `DataBunch` is a simple object which contains labeled training and validation `Dataset`s.

```swift
let data = transformData(rawData) { openAndResize(fname: $0, size: 128) }
```

We can add any lazily-applied transformations we need to convert (for instance) raw file names into data ready for modeling (in this case, images of the same size).

```swift
func modelInit() -> XResNet { return xresnet18(cOut: 10) }
let optFunc: (XResNet) -> StatefulOptimizer<XResNet> = adamOpt(lr: 1e-3, mom: 0.9, beta: 0.99, wd: 1e-2, eps: 1e-4)
let learner = Learner(data: data, lossFunc: softmaxCrossEntropy, optFunc: optFunc, modelInit: modelInit)
```

A `Learner` is an object that knows how apply an `Optimizer` (in this case, `adamOpt`, which defaults to [AdamW](https://www.fast.ai/2018/07/02/adam-weight-decay/)) to train a model (`xresnet18`) based on some `DataBunch`, to minimize some differentiable loss function (`softmaxCrossEntropy`).

```swift
let recorder = learner.makeDefaultDelegates(metrics: [accuracy])
learner.addDelegate(learner.makeNormalize(mean: imagenetStats.mean, std: imagenetStats.std))
learner.addOneCycleDelegates(1e-3, pctStart: 0.5)
```

Delegates are used to customize training in many ways. In this case, we're adding delegates to:

- Record losses and metrics after each batch, add a progress bar, and move data to the GPU (these are all *default delegates* in SwiftAI)
- Normalize the data
- Use the [1 cycle policy](https://sgugger.github.io/the-1cycle-policy.html)

```swift
try! learner.fit(1)
```

The `fit` method will train and validate your model for as many epochs as you request.
