import router from '@ohos.router'
import http from '@ohos.net.http';
import { userId, username } from './Login';
import { BottomList } from '../view/BottomList'

function PostArticle(content: String, userName: String, title: String) {
  let httpRequest = http.createHttp();
  httpRequest.on('headersReceive', (header) => {
    console.info('header: ' + JSON.stringify(header));
  });

  httpRequest.request(
    "172.29.4.130:8888/post/add",
    {
      header: {
        'Content-Type': 'application/json'
      },
      method: http.RequestMethod.POST,
      extraData: {
        "username": userName,
        "content": content,
        "title": title,
        "userId": userId,
        "commentNumber": 0
      },
      connectTimeout: 6000,
      readTimeout: 6000,
    }, (err, data) => {
    if (!err) {
      if (JSON.parse(data.result.toString()).code == 1) {
        router.pushUrl({
          url: "pages/MedicalCommunity"
        })
      }
      console.log(JSON.parse(data.result.toString()).msg + "sss")

    } else {
      console.info('error:' + JSON.stringify(err));
      httpRequest.off('headersReceive');
      httpRequest.destroy();
    }
  }
  );
}


@Entry
@Component
struct AddPost {
  @State title: string = ""
  @State article: string = ""

  build() {
    Column() {
      Column() {
        Button() {
          Text("取消")
        }
        .backgroundColor('#ffdedbdb')
        .height('50%')
        .width('20%')
        .position({
          x: '0%',
          y: '25%'
        })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/MedicalCommunity'
          });
        })

        Text("发帖")
          .height('50%')
          .width('50%')
          .fontSize(20)
          .textAlign(TextAlign.Center)
          .position({
            y: '25%',
            x:'25%'
          })


        Button() {
          Text("发布")
            .fontColor(Color.White)
        }
        .onClick(() => {
          PostArticle(this.article, username, this.title)
        })
        .backgroundColor('#ff7e10cb')
        .height('50%')
        .width('20%')
        .position({

          x: '80%',
          y: '25%'
        })
      }
      .height('8%')
      .width('100%')
      .backgroundColor(Color.White)

      Column() {
        TextInput({
          placeholder: "请输入标题"
        })
          .height('10%')
          .width('100%')
          .position({
            x: '0%',
            y: '2%'
          })
          .onChange((value: string) => {
            this.title = value
          })

        TextArea({
          placeholder: "请输入内容"
        })
          .height('70%')
          .width('100%')
          .position({
            x: '0%',
            y: '15%'
          })
          .onChange((value: string) => {
            this.article = value
          })
      }
      .height('84.5%')
      .width('100%')
      .backgroundColor(Color.White)

      Row() {
        BottomList({
          chosenIndex: 2
        })
      }.layoutWeight(2)

    }
    .height('100%')
    .width('100%')
    .backgroundColor('#ffdedbdb')
  }
}