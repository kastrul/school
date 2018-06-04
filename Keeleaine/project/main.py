import os

import gensim
import pandas as pd
from nltk.corpus import stopwords

stop_words = stopwords.words('english')

ENCODING = 'iso-8859-1'
COL_Q = ['Id', 'Body']
COL_A = ['ParentId', 'Body']
N_ROWS = 100000
PATH_ANSWERS = 'data/stacksample/Answers.csv'
PATH_QUESTIONS = 'data/stacksample/Questions.csv'
path_TAGS = 'data/stacksample/Tags.csv'

df_questions = pd.read_csv(PATH_QUESTIONS, encoding=ENCODING, low_memory=False, usecols=COL_Q, nrows=N_ROWS)
df_tags = pd.read_csv(path_TAGS, encoding=ENCODING, low_memory=False)


def remove_stopwords(sentence):
    return [word for word in sentence if word not in stop_words]


def prepare_data(text_data, tag_data):
    dataset = {
        'text': [],
        'tags': []
    }
    n_rows = len(text_data)
    for idx, row in enumerate(text_data):
        print_state(idx, n_rows)
        text = remove_stopwords(gensim.utils.simple_preprocess(str(row[1]), deacc=True))
        tags = [tag[1] for tag in tag_data[tag_data['Id'] == row[0]]]
        dataset['text'].append(text)
        dataset['tags'].append(tags)
    return dataset


def print_state(current, target):
    restart_line()
    print('Row {0}/{1}'.format(current, target), end='')


def restart_line():
    os.system('cls')


data = prepare_data(df_questions.values, df_tags)

if __name__ == '__main__':
    data = prepare_data(df_questions.values, df_tags)
    df = pd.DataFrame(data, columns=['text', 'tags'])
    df.to_csv('data/stacksample/dataset.csv')
