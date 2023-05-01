import json
import urllib.parse
import boto3

s3 = boto3.client('s3')

def lambda_handler(event, context):
    # バケット名とファイルパスを取得
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    
    # ファイルパスからフォルダ名を取得
    folder_name = file_key.split('/')[-2]
    
    # フォルダ名が'test'である場合に限り、ファイル名を取得
    if folder_name == 'test':
        file_name = file_key.split('/')[-1]
        print('ファイル名:', file_name)
    else:
        print('フォルダ名がtestではありません')
