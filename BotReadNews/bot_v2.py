import requests
from bs4 import BeautifulSoup
import config
import datetime
import xlrd

import pymongo
from pymongo import MongoClient

#Step 1: Connect to MongoDB - Note: Change connection string as needed
client = MongoClient("mongodb+srv://elle:BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net/Tocsin?retryWrites=true&w=majority")
db = client["tocsin"]
news_coll = db["news"]


keywordsScraper = []
provincesConfig = []

wb = xlrd.open_workbook("config.xlsx")
ws_keywords = wb.sheet_by_name('keywords')
for row in range(ws_keywords.nrows) :
    keywordsScraper.append(ws_keywords.cell_value(row, 0))
ws_provinces = wb.sheet_by_name('provinces')
for row in range(ws_provinces.nrows) :
    provincesConfig.append(ws_provinces.cell_value(row, 0))


class Scraper:
    def __init__(self, keywords, provinces):
        self.markup = requests.get('https://www.sanook.com/news/crime/').text
        self.keywords = keywords
        self.saved_links = []
        self.saved_titles = []
        self.proofed_links = []
        self.proofed_titles = []
        self.final_links = []
        self.final_titles = []
        self.timestamp_lists = []

        self.provinces = provinces

    def parse(self):
        soup = BeautifulSoup(self.markup, 'html.parser')
        links = soup.findAll("a", href=True)
        for link in links:
            for keyword in self.keywords:
                if keyword in link.text:
                    self.saved_links.append('https:' + link['href'])
                    self.saved_titles.append(link['title'])

    def check(self):
        if len(self.saved_links) > 0 :
            for saved_link, saved_title in zip(self.saved_links, self.saved_titles) :
                if saved_link not in self.proofed_links :
                    self.proofed_links.append(saved_link)
                    self.proofed_titles.append(saved_title)
                    # print(saved_link)

        if len(self.proofed_links) > 0 :
            for proofed_link, proofed_title in zip(self.proofed_links, self.proofed_titles) :
                news_checks = []
                checks = news_coll.find({'link':proofed_link})
                for check in checks:
                    news_checks.append(check['link'])
                if proofed_link not in news_checks :
                    datetime_ = datetime.datetime.now()
                    self.final_links.append(proofed_link)
                    self.final_titles.append(proofed_title)
                    self.timestamp_lists.append(datetime_)
                    print(proofed_link)

    def store(self):
        if len(self.final_links) > 0:
            for i in range(len(self.final_links)):
                soup = BeautifulSoup(requests.get(self.final_links[i]).text, 'html.parser')
                paragraphs = soup.find('div', {'id': 'EntryReader_0'}).find('p')
                saved_paragraphs = []
                for paragraph in paragraphs:
                    for province in self.provinces:
                        if province in paragraph:
                            saved_paragraphs.append(str(paragraph))
                            print(paragraph)
                if len(saved_paragraphs) == 0:
                    saved_paragraphs.append('cannot find address')

                datetime_ = datetime.datetime.now()

                news = {
                    'link': self.final_links[i],
                    'title': self.final_titles[i],
                    'status': 'Waiting',
                    'contents': saved_paragraphs,
                    'created_at': datetime_,
                    'updated_at': datetime_
                }
                #Step 3: Insert business object directly into MongoDB via isnert_one
                news_coll.insert_one(news)
                print('Inserted News')
        else : 
            print('Nothing Insert')

readNews = Scraper(keywordsScraper, provincesConfig)
readNews.parse()
readNews.check()
readNews.store()
