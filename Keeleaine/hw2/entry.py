#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 16 11:29:11 2018

@author: jan
"""
import sys
import torch
import torch.autograd as autograd
import torch.nn as nn
from models import CbowSum, CbowMean, CnnText
import torch.nn.functional as F
import torchtext.data as data
import torchtext.datasets as datasets



TEXT = data.Field(lower=True, batch_first=True)
LABEL = data.Field(sequential=False)
train_data, test_data = datasets.IMDB.splits(TEXT, LABEL)
TEXT.build_vocab(train_data,  max_size=10000)
LABEL.build_vocab(train_data)

train_iter, test_iter = data.BucketIterator.splits((train_data, test_data), batch_size=32, device=-1, repeat=False)

batch = next(iter(train_iter))

def train(model, num_epochs, train_iter, test_iter, log_interval=10):

  optimizer = torch.optim.Adam(model.parameters())

  steps = 0
  best_acc = 0
  last_step = 0
  model.train()
  for epoch in range(1, num_epochs+1):
    for batch in train_iter:
      text, target = batch.text, batch.label

      # subtract one from label ID because we don't have <unk> labels
      target -= 1

      optimizer.zero_grad()
      logit = model(text)

      #print('logit vector', logit.size())
      #print('target vector', target.size())
      loss = F.cross_entropy(logit, target)
      loss.backward()
      optimizer.step()

      steps += 1
      if steps % log_interval == 0:
        corrects = (torch.max(logit, 1)[1].view(target.size()).data == target.data).sum()
        accuracy = 100.0 * corrects/batch.batch_size
        sys.stdout.write('\rEpoch: {} batch[{}] - loss: {:.6f}  acc: {:.4f}%({}/{})'.format(epoch, steps, 
                                                                     loss.data[0], 
                                                                     accuracy,
                                                                     corrects,
                                                                     batch.batch_size))
    dev_acc = evaluate(test_iter, model)


def evaluate(data_iter, model):
  
  model.eval()
  corrects, avg_loss = 0, 0
  for batch in data_iter:
    text, target = batch.text, batch.label

    # subtract one from label ID because we don't have <unk> labels
    target -= 1
    logit = model(text)
    loss = F.cross_entropy(logit, target, size_average=False)

    avg_loss += loss.data[0]
    corrects += (torch.max(logit, 1)[1].view(target.size()).data == target.data).sum()

  size = len(data_iter.dataset)
  avg_loss /= size
  accuracy = 100.0 * corrects/size
  print('\nEvaluation - loss: {:.6f}  acc: {:.4f}%({}/{}) \n'.format(avg_loss, 
                                                                     accuracy, 
                                                                     corrects, 
                                                                     size))
  return accuracy


def evaluate_interpolated(data_iter, models):
  
  # This turns off dropout for every model used.
  for model in models:
      model.eval()
      
  corrects, avg_loss = 0, 0
  
  for batch in data_iter:
    text, target = batch.text, batch.label

    # subtract one from label ID because we don't have <unk> labels
    target -= 1
    classes = []
    for model in models:
        # Use softmax to normalize the matrices so that the sum of all elements is 1
        nsoft = F.softmax(model(text), dim=1)
        # Make an array of these matrices to sum over them later on
        classes.append(nsoft)
    
    # Use stack method to make a torch array from a list
    out = torch.stack(classes)
    # Use the number of classes to later divide over the sum
    classes_n = out.shape[0]
    # Sum over the specified dimension
    out = torch.sum(out, 0)
    # Divide the summation to normalse
    out = torch.div(out, classes_n)
    
    loss = F.cross_entropy(out, target, size_average=False)

    avg_loss += loss.data[0]
    corrects += (torch.max(out, 1)[1].view(target.size()).data == target.data).sum()

  size = len(data_iter.dataset)
  avg_loss /= size
  accuracy = 100.0 * corrects/size
  print('\nEvaluation - loss: {:.6f}  acc: {:.4f}%({}/{}) \n'.format(avg_loss, 
                                                                     accuracy, 
                                                                     corrects, 
                                                                     size))
  return accuracy                

model1 = CbowSum(2, len(TEXT.vocab), 50, 0.5)
model2 = CbowMean(2, len(TEXT.vocab), 50, 0.5)
model3 = CnnText(2, len(TEXT.vocab), 50, 0.5)

train(model1, 3, train_iter, test_iter)
train(model2, 3, train_iter, test_iter)
train(model3, 3, train_iter, test_iter)

evaluate_interpolated(test_iter, [model1, model2, model3])
