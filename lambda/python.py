import json

def lambda_handler(event, context):
    message = event['Records'][0]['Sns']['Message']
    message = json.loads(message)
    
    account_id = message['accountId']
    region = message['region']
    finding_type = message['detail']['type']
    severity = message['detail']['severity']
    title = message['detail']['title']
    description = message['detail']['description']
    
    formatted_message = f"GuardDuty Finding:\nAccount ID: {account_id}\nRegion: {region}\nFinding Type: {finding_type}\nSeverity: {severity}\nTitle: {title}\nDescription: {description}"
    
    return {
        'statusCode': 200,
        'body': formatted_message
    }
