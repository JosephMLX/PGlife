import requests
import json
import time

url = 'http://poll.nestaward.com/ajax/project/ballot?callback=jQuery20004547437401334016_1556791941303&id=30213219&_=1556791941901'
proxies = [line.rstrip() for line in open('proxies.txt')]


# def vote(p):
#     print("current IP: ", p)
#     # print(using_proxy)
#     r = requests.get(url, proxies={'http': p})
#     print(r.status_code)
# vote()

def main():
    tickets = 0
    for i in range(len(proxies)):
        cur_IP = proxies[i]
        print("Now using:", cur_IP)
        # for j in range(5):
            # print('time: ', j)
            # vote(cur_IP)
            # time.sleep(5)
            # try:
        try:
            r = requests.get(url, proxies={'http': cur_IP}, timeout=(10, 20))
            if r.status_code == 200:
                tickets += 1
                print("vote successfully, voted time:", 1)
                print("Total tickets this execuation:", tickets)
                time.sleep(5)
                for j in range(4): 
                    requests.get(url, proxies={'http': cur_IP}, timeout=(10, 20))
                    print("vote successfully, voted time:", j+2)
                    tickets += 1
                    print("Total tickets this execuation:", tickets)
                    time.sleep(5)
        # except requests.exceptions.ConnectTimeout:
        #     print(cur_IP, 'occurs connection time out')
            # continue
        except requests.exceptions.RequestException as e:
            print(e)
        except requests.ReadTimeout as e:
            print(e)
        # except requests.ConnectionError:
        #     print(cur_IP, 'occurs connection error')
        #     # continue
        # except requests.HTTPError:
        #     print("Danm, bad network!")
        #     pass
        # except requests.exceptions.ProxyError:
        #     print("what?")
        #     # continue
main()    