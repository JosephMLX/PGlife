from __future__ import print_function
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import pickle
import os.path
import pandas as pd

SCOPES = ['https://www.googleapis.com/auth/spreadsheets.readonly']

# The ID and range of a sample spreadsheet.
SAMPLE_SPREADSHEET_ID = '1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms'
SAMPLE_RANGE_NAME = 'Class Data!A2:E'

def get_google_sheet(spreadsheet_id, range_name):
    """Shows basic usage of the Sheets API.
    Prints values from a sample spreadsheet.
    """
    creds = None
    # See if there is a token.dat from a previous run
    # that contains the required credentials.
    if os.path.exists('token.dat'):
        with open('token.dat', 'rb') as token:
            creds = pickle.load(token)
        # The token expires after an hour and may need to be refreshed.
        if creds.expired:
            creds.refresh(Request())
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        flow = InstalledAppFlow.from_client_secrets_file(
            'credentials.json', SCOPES)
        creds = flow.run_local_server()
    # Save the credentials for the next run
    with open('token.dat', 'wb') as token:
        pickle.dump(creds, token)

    service = build('sheets', 'v4', credentials=creds)
    
    # Call the Sheets API
    sheet = service.spreadsheets()
    result = sheet.values().get(spreadsheetId=spreadsheet_id,
                                range=range_name).execute()
    """values = result.get('values', [])

    if not values:
        print('No data found.')
    else:
        print('Name, Major:')
        for row in values:
            # Print columns A and E, which correspond to indices 0 and 4.
            print('%s, %s' % (row[0], row[4]))
    """
    return result

def gsheet2df(gsheet):
    header = gsheet.get('values', [])[0]
    values = gsheet.get('values', [])[1:]
    if not values:
        print('No data found.')
    else:
        all_data = []
	for col_id, col_name in enumerate(header):
	    column_data = []
	    for row in values:
		column_data.append(row[col_id])
	    ds = pd.Series(data=column_data, name=col_name)
	    all_data.append(ds)
	df = pd.concat(all_data, axis=1)
	return df

if __name__ == '__main__':
    gsheet = get_google_sheet(SAMPLE_SPREADSHEET_ID, SAMPLE_RANGE_NAME)
    df = gsheet2df(gsheet)
    print('Dataframe size = ', df.shape)
    print(df.head())

