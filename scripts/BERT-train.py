from bert_serving.client import BertClient
bc = BertClient()
vectors=bc.encode("list of all the word")