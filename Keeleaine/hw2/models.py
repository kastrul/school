# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import torch
import torch.nn as nn
import torch.nn.functional as F

class CbowSum(nn.Module):
    
    def __init__(self, num_classes, vocab_size, embedding_dim, dropout_prob):
        super(CbowSum, self).__init__()
        self.embed = nn.Embedding(vocab_size, embedding_dim)      
        self.lin1 = nn.Linear(embedding_dim, 100)
        self.dropout = nn.Dropout(dropout_prob)
        self.fc = nn.Linear(100, num_classes)
    
    def forward(self, x):
        x = self.embed(x)        
        x = self.sum_rows(x)
        x = F.relu(self.lin1(x))
        x = self.dropout(x)        
        return self.fc(x)    
    
    def sum_rows(self, x):
        return torch.sum(x, 1)
    
class CbowMean(nn.Module):
    
    def __init__(self, num_classes, vocab_size, embedding_dim, dropout_prob):
        super(CbowMean, self).__init__()
        self.embed = nn.Embedding(vocab_size, embedding_dim)      
        self.lin1 = nn.Linear(embedding_dim, 100)
        self.dropout = nn.Dropout(dropout_prob)
        self.fc = nn.Linear(100, num_classes)
    
    def forward(self, x):
        x = self.embed(x)        
        x = self.mean_rows(x)
        x = F.relu(self.lin1(x))
        x = self.dropout(x)        
        return self.fc(x)    
    
    def mean_rows(self, x):
        n_rows = x.shape[0]
        x = torch.sum(x, 1)
        return torch.div(x, n_rows)
    
class CnnText(nn.Module):
  
    def __init__(self, num_classes, vocab_size, embedding_dim, dropout_prob):
        super(CnnText, self).__init__()
        self.embed = nn.Embedding(vocab_size, embedding_dim)
        self.conv1 = nn.Conv1d(embedding_dim, 32, kernel_size=3, stride=1)
        self.conv2 = nn.Conv1d(32, 64, kernel_size=3, stride=1)
        self.conv3 = nn.Conv1d(64, 64, kernel_size=3, stride=1)
        self.dropout = nn.Dropout(dropout_prob)
        self.fc = nn.Linear(64, num_classes)
    
    def forward(self, x):
        # Conv1d takes in (batch, channels, seq_len), but raw embedded is (batch, seq_len, channels)
        x = self.embed(x).permute(0, 2, 1)
        #print(x.shape)
        x = F.relu(self.conv1(x))
        #print(x.shape)
        x = F.max_pool1d(x, 2)
        #print(x.shape)
        x = F.relu(self.conv2(x))
        #print(x.shape)
        x = F.relu(self.conv3(x))
        #print(x.shape)
        x = F.max_pool1d(x, x.size(2))
        #print(x.shape)
        x = x.view(-1, 64)
        #print(x.shape)
        x = self.dropout(x) 
        logit = self.fc(x)
        return logit