import requests

dictionary = {
    '2011': ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
    '2012': ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
    '2013': ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
    '2014': ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
    '2015': ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
    '2016': ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
    '2017': ['01', '02'],
}

for year in dictionary.keys():
    for month in dictionary[year]:
        print('Downloading file bolsa_familia_{year}{month}.zip ...'.format(year=year, month=month))

        session = requests.Session()
        raw = session.get('http://arquivos.portaldatransparencia.gov.br/downloads.asp?a={year}&m={month}&consulta=BolsaFamiliaFolhaPagamento'.format(year=year, month=month))

        with open('./data/bolsa_familia_{year}{month}.zip'.format(year=year, month=month), 'wb') as file:
            file.write(raw.content)
            print('File bolsa_familia_{year}{month}.zip downloaded!'.format(year=year, month=month))
