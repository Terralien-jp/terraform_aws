import os
import boto3
import tempfile
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication
from email.mime.text import MIMEText

def lambda_handler(event, context):
    s3_client = boto3.client('s3')
    ses_client = boto3.client('ses')

    # S3イベントからバケット名とオブジェクトキーを取得
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    object_key = event['Records'][0]['s3']['object']['key']

    # S3からファイルを取得
    s3_object = s3_client.get_object(Bucket=bucket_name, Key=object_key)
    file_content = s3_object['Body'].read()

    # ファイルをメールの添付ファイルとして追加
    attachment = MIMEApplication(file_content, Name=object_key)
    attachment.add_header('Content-Disposition', 'attachment', filename=object_key)

    # メール本文の設定
    body = MIMEText('Please find the attached file.')

    # メールメッセージの作成
    message = MIMEMultipart()
    message.attach(body)
    message.attach(attachment)
    message['Subject'] = 'File from S3'
    message['From'] = os.environ['SENDER_EMAIL']
    message['To'] = os.environ['RECIPIENT_EMAIL']

    # メールの送信
    ses_client.send_raw_email(
        Source=message['From'],
        Destinations=[message['To']],
        RawMessage={'Data': message.as_string()}
    )

    return {
        'statusCode': 200,
        'body': 'Email sent successfully.'
    }
