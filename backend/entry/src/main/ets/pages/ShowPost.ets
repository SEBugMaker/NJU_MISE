import router from '@ohos.router'
import http from '@ohos.net.http';

import { PostContent } from './MedicalCommunity';
import { userId, username } from './Login';
import { imageMap } from '../common/constants/CommonConstants';


export class PostCommentContent {
  commentId: number;
  postId: string;
  userName: string;
  publishTime: string;
  content: string;

  constructor(postId: string, username: string, publishTime: string, content: string, commentId: number) {
    this.userName = username
    this.content = content;
    this.commentId = commentId
    this.publishTime = publishTime
    this.postId = postId
  }
}

@Entry
@Component
struct ShowPost {
  @State postId: string = router.getParams()?.['postId'];
  @State PostCommentList: PostCommentContent[] = []
  @State postToShow: PostContent = router.getParams()?.['postToShow'];
  dialogController: CustomDialogController = new CustomDialogController({
    builder: Record({
      postId: this.postId,
      confirm: () => this.a()
    }),
    cancel: () => this.a(),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    customStyle: true

  })

  a() {
    this.GetPostComments()
  }

  aboutToAppear() {
    this.GetPostComments()
  }

  onPageShow() {
    this.GetPostComments()
  }

  build() {
    Column() {
      Row() {
        Image($r("app.media.back_icon"))
          .onClick(() => {
            router.back()
          })
          .height(30)
          .width(30)

        Image($r("app.media.add_icon"))
          .onClick(() => {
            this.dialogController.open()
          })
          .height(30)
          .width(30)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(45)
      .backgroundColor('#ffe4e4e5')
      .layoutWeight(1)



      List() {
        ListItem() {
          Column() {
            Text(this.postToShow.title)
              .fontSize(25)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .textAlign(TextAlign.Center)
              .padding(2)
              .width('100%')
            Text(this.postToShow.userName)
              .fontSize(17)
              .maxLines(1)
              .fontColor("#ff080908")
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .textAlign(TextAlign.Center)
              .padding(3)
              .width('100%')
            Text(this.postToShow.content)
              .fontSize(18)
            Row() {
              Text(this.postToShow.publishTime)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontSize(15)
                .fontColor("#ff8d8a8a")
                .layoutWeight(15)
              Image($r("app.media.comment"))
                .layoutWeight(1)
                .width(15)
              Blank()
                .layoutWeight(1)
              Text(this.postToShow.comment_count.toString())
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontColor("#ff8d8a8a")
                .fontSize(15)
                .layoutWeight(3)
            }

            Row() {
              Blank()
                .height(15)
            }
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .borderRadius(30)

        }

        ListItem() {

            Text('评论区')
              .textAlign(TextAlign.Center)
              .padding(10)
              .fontSize(20)
              .width('100%')

        }

        ForEach(this.PostCommentList, (item: PostCommentContent) => {
          ListItem() {
            comment({
              avatar: imageMap.get(item.userName),
              username: item.userName,
              comment: item.content,
              date: item.publishTime
            })
            // Column() {
            //   Blank()
            //     .height(15)
            //   Row() {
            //     Text(item.userName + ":")
            //       .fontSize(20)
            //       .maxLines(1)
            //       .textOverflow({ overflow: TextOverflow.Ellipsis })
            //     Text(item.content)
            //       .textOverflow({ overflow: TextOverflow.Ellipsis })
            //
            //       .fontSize(15)
            //   }
            //   .width("90%")
            //   Blank()
            //     .height(5)
            //   Text(item.publishTime)
            //     .textOverflow({ overflow: TextOverflow.Ellipsis })
            //     .fontSize(10)
            //     .textAlign(TextAlign.End)
            //     .fontColor("#ff8d8a8a")
            //   Blank()
            //     .height(15)
            // }
            // .width('100%')
            //
            // .alignItems(HorizontalAlign.Start)
          }
        })
      }
      .width('100%')
      .scrollBar(BarState.Auto)
      .divider({
        strokeWidth: 1,
        startMargin: 60,
        endMargin: 10,
        color: '#ffe9f0f0'
      })
      .layoutWeight(16)
    }

  }

  GetPostComments() {
    let httpRequest = http.createHttp();
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });

    httpRequest.request(
      "172.29.4.130:8888/comment/page?postId=" + this.postId + "&page=1&pageSize=10",
      {
        header: {
          'Content-Type': 'application/json'
        },
      }, (err, data) => {
      if (!err) {
        if (JSON.parse(data.result.toString()).code == 1) {
          const parsedResponse = JSON.parse(data.result.toString());
          var Posts: PostCommentContent[] = []
          for (let i = 0; i < (parsedResponse.data.total > parsedResponse.data.size ? parsedResponse.data.size : parsedResponse.data.total); i++) {
            Posts.push(new PostCommentContent(parsedResponse.data.records[i].postId, parsedResponse.data.records[i].username
              , parsedResponse.data.records[i].createTime, parsedResponse.data.records[i].content,
              parsedResponse.data.records[i].id))
          }
          this.PostCommentList = Posts
        }


      } else {
        console.info('error:' + JSON.stringify(err));
        httpRequest.off('headersReceive');
        httpRequest.destroy();
      }
    }
    );
  }
}


@CustomDialog
struct Record {
  private controller?: CustomDialogController;
  private content: string = null;
  private postId: string;
  @State editing: boolean = false;
  confirm: () => void

  build() {
    Column() {
      Row({ space: 6 }) {
        Column() {
          TextInput({ placeholder: this.editing ? '评论内容不能为空' : '请输入评论内容' })
            .placeholderColor(this.editing ? '#fff50909' : Color.Grey)
            .onChange((value: string) => {
              this.content = value;
            })
            .width('90%')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('app.color.white'))
      }
      .height(128)


      Button("发布", { type: ButtonType.Capsule, stateEffect: true })
        .height(43)
        .width('90%')
        .backgroundColor("#ff5a04b0")
        .margin({ top: 33, left: 72, right: 72 })
        .onClick(() => {
          if (this.content !== null && this.content !== '') {
            PostComment(this.content, username, this.postId, userId)
            this.content = null
            setTimeout(() => {
              this.confirm()
            }, 500)
            if (this.controller !== undefined) {
              this.controller.close()
            }
          } else {
            this.editing = true
            // AlertDialog.show({
            //   message: 'wrong',
            //   autoCancel: true
            // })
          }


        })
    }
    .height(254)
    .width('90%')
    .backgroundColor($r('app.color.white'))
  }
}


function PostComment(content: String, userName: String, postId: string, userId: BigInt) {
  let httpRequest = http.createHttp();
  httpRequest.on('headersReceive', (header) => {
    console.info('header: ' + JSON.stringify(header));
  });

  httpRequest.request(

    "172.29.4.130:8888/comment/add",
    {
      // 开发者根据自身业务需要添加header字段
      header: {
        'Content-Type': 'application/json'
      },
      method: http.RequestMethod.POST,
      extraData: {
        "username": userName,
        "userId": userId,
        "content": content,
        "postId": postId
      },
      connectTimeout: 6000,
      readTimeout: 6000,
    }, (err, data) => {
    if (!err) {

    } else {
      console.info('error:' + JSON.stringify(err));
      httpRequest.off('headersReceive');
      httpRequest.destroy();
    }
  }
  );
}
@Component
struct comment {
  private avatar: string = 'https://bu.dusays.com/2023/12/23/658630e282ee9.jpg'
  private username:string = ''
  private comment:string = ''
  private date:string = ''
  build() {
    Column() {

      Row() {
        Image(this.avatar)
          .height(50)
          .width(50)
          .borderRadius(30)
          .position({
            x: 5,
            y: 5
          })
        Text(' '+this.username)
          .fontSize(20)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .position({
            x:60,
            y:15
          })
      }
      .width("90%")
      Row(){
        Text(this.comment)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

          .fontSize(20)
      }
      .position({
        x:25,
        y:60
      })
      Blank()
        .height(5)
      Text(this.date)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontSize(15)
        .textAlign(TextAlign.End)
        .fontColor("#ff8d8a8a")
        .position({
          x: '60%',
          y: 100
        })
    }
    .height(130)
    .width('100%')
    .backgroundColor("#FFFF")
  }
}

