import router from '@ohos.router'
import http from '@ohos.net.http';
import { BottomList } from '../view/BottomList'
import { userId,username } from './Login';
import { PostContent } from './MedicalCommunity';


@Entry
@Component
struct MyPost{
  @State PostList:PostContent[]=[]
  onPageShow(){
    this.GetPosts()
  }

  build() {
    Column() {
      Row(){
        Image($r("app.media.back_icon"))
          .onClick(() => {
            router.back()
          })
          .height(30)
          .width(30)

        Text("我的帖子")
          .textAlign(TextAlign.Center)
          .fontSize(25)

        Image($r("app.media.add_icon"))
          .onClick(() => {
            router.pushUrl(
              {
                url: 'pages/AddPost'
              }
            )
          })
          .height(30)
          .width(30)

      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(45)
      .backgroundColor('#ffe4e4e5')

      List() {
        ForEach(this.PostList , (item: PostContent) => {
          ListItem() {
            Column() {
              Text(item.title)
                .fontSize(25)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .textAlign(TextAlign.Center)
                .padding(2)
                .width('100%')
              Text("——" + item.userName)
                .fontSize(20)
                .maxLines(1)
                .fontColor("#ff11661a")
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .textAlign(TextAlign.End)
                .padding(2)
                .width('100%')
              Text(item.content)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(3)
                .fontSize(18)
                .padding(10)

              Row() {
                Text(item.publishTime)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .fontSize(15)
                  .fontColor("#ff8d8a8a")
                  .layoutWeight(15)
                Image($r("app.media.comment"))
                  .layoutWeight(1)
                  .width(15)
                Blank()
                  .layoutWeight(1)
                Text(item.comment_count.toString())
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .fontColor("#ff8d8a8a")
                  .fontSize(15)
                  .layoutWeight(3)
              }
            }
            .width('100%')

            .alignItems(HorizontalAlign.Start)
          }
          .border({ width: 3, color: '#FFFF', radius: 30, style: BorderStyle.Solid })
          .padding(10)
          .backgroundColor(Color.White)
          .onClick(() => {
            router.pushUrl({
              url:'pages/ShowPost',
              params:{
                postId: item.postId,
                postToShow:item
              }
            })
          })
        })
      }
      .width('100%')
      .scrollBar(BarState.Auto)
      .divider({
        strokeWidth: 2,
        startMargin: 60,
        endMargin: 10,
        color: '#ffe9f0f0'
      })
      .layoutWeight(10)

      Row(){
        BottomList({
          chosenIndex:2
        })
      }
      .layoutWeight(1)
    }
    .backgroundColor("#F1F3F5")
  }

  GetPosts(){
    let httpRequest = http.createHttp();
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(
      "172.29.4.130:8888/post/page?page=1&pageSize=20",
      {
        header: {
          'Content-Type': 'application/json'
        },
        connectTimeout: 6000,
        readTimeout: 6000,
      }, (err, data) => {
      if (!err) {
        if(JSON.parse(data.result.toString()).code==1){
          const parsedResponse = JSON.parse(data.result.toString());
          var Posts: PostContent[] = []
          for (let i = 0; i <(parsedResponse.data.total>parsedResponse.data.size?parsedResponse.data.size:parsedResponse.data.total) ; i++) {
            if(parsedResponse.data.records[i].username == username){
              Posts.push(new PostContent(parsedResponse.data.records[i].id ,parsedResponse.data.records[i].username
                ,parsedResponse.data.records[i].createTime , parsedResponse.data.records[i].content ,
                parsedResponse.data.records[i].commentNumber,parsedResponse.data.records[i].title))
            }
          }
          this.PostList = Posts
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