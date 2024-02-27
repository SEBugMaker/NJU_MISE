import router from '@ohos.router'
import http from '@ohos.net.http';
import { BottomList } from '../view/BottomList'
import { emailMap, imageMap } from '../common/constants/CommonConstants';
import { CommonConstants as Const } from '../common/constants/CommonConstants';

export class PostContent {
  postId: string;
  userName: string;
  publishTime : string;
  content : string;
  comment_count : number;
  title:string;

  constructor(postId:string,username: string,publishTime:string, content: string, comment_count:number,title:string) {
    this.userName = username
    this.content = content;
    this.comment_count = comment_count
    this.publishTime = publishTime
    this.postId = postId
    this.title = title
  }

}

@Entry
@Component
struct MedicalCommunity {
  @State PostList:PostContent[]=[]
  @State arrowIconOpacity: number = Const.OPACITY_MAX;
  count:number = 2;
  total:number = 0;
  pageSize:number =5;
  onPageShow(){
    this.GetPosts()
  }
  build() {
    Column() {
      Stack(){
        Row(){
          Text("医学社区")
            .textAlign(TextAlign.Center)
            .fontSize(25)
        }
        .justifyContent(FlexAlign.Center)
        Row(){
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
          Text("  ")
        }
        .width('100%')
        .justifyContent(FlexAlign.End)


      }
      //.justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(45)
      .backgroundColor('#FFFF')

      List() {
        ForEach(this.PostList , (item: PostContent) => {
          ListItem() {
            post_view({
              username: item.userName,
              email:emailMap.get(item.userName),
              content: item.content,
              title:item.title,
              date:item.publishTime,
              num:item.comment_count.toString(),
              avatar: imageMap.get(item.userName)
            })

          }
          .border({ width: 3, color: '#FFFF', radius: 30, style: BorderStyle.Solid })
          .padding(10)
          .backgroundColor('#FFFF')
          .shadow({
            color: 'rgba(0, 0, 0, 0.12)',
            radius: 30,
            offsetX: 1,
            offsetY: 1,
          })
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
      .onReachEnd( () =>{
        if((this.count-1)*this.pageSize <  this.total){
          this.GetMorePosts(this.count)
          this.count++
        }
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
      "172.29.4.130:8888/post/page?page=1&pageSize="+this.pageSize,
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
          this.total = parsedResponse.data.total
          var Posts: PostContent[] = []
          for (let i = 0; i <(parsedResponse.data.total>parsedResponse.data.size?parsedResponse.data.size:parsedResponse.data.total) ; i++) {
            Posts.push(new PostContent(parsedResponse.data.records[i].id ,parsedResponse.data.records[i].username
              ,parsedResponse.data.records[i].createTime , parsedResponse.data.records[i].content ,
              parsedResponse.data.records[i].commentNumber,parsedResponse.data.records[i].title))
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

  GetMorePosts(count:number){
    let httpRequest = http.createHttp();
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(
      "172.29.4.130:8888/post/page?page="+count+"&pageSize="+this.pageSize,
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
          for (let i =0;
               i <(parsedResponse.data.total-( parsedResponse.data.current-1)*parsedResponse.data.size>parsedResponse.data.size?
                 parsedResponse.data.size:
                 -( parsedResponse.data.current-1)*parsedResponse.data.size+parsedResponse.data.total) ;
               i++) {
            this.PostList.push(new PostContent(parsedResponse.data.records[i].id ,parsedResponse.data.records[i].username
              ,parsedResponse.data.records[i].createTime , parsedResponse.data.records[i].content ,
              parsedResponse.data.records[i].commentNumber,parsedResponse.data.records[i].title))
          }
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


@Component
struct post_view{
  private username: string
  private email: string
  private content: string
  private title: string
  private date: string
  private num: string
  private avatar: string
  build() {
    Column() {
      Row() {
        Image(this.avatar)
          .width(50)
          .height(50)
          .borderRadius(100)
        Column() {
          Text(' ' + this.username)
            .fontSize(25)
            .fontColor(Color.Black)
          Text("  "+this.email)
            .fontSize($r('app.float.little_text_size'))
            .margin({ top: $r('app.float.setting_name_margin') })
        }
      }
      .position({
        x: 10,
        y: 10
      })

      Text(this.title)
        .fontSize(25)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding(2)
        .width('100%')
        .height(30)
        .position({
          y: 70,
          x: 20
        })

      Text(this.content)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(3)
        .fontSize(18)
        .padding(10)
        .height(40)
        .position({
          x: 10,
          y: 100
        })

      // Image('https://bu.dusays.com/2023/12/23/658630e282ee9.jpg')
      //   .width(70)
      //   .height(70)
      //   .align(Alignment.Center)
      //   .position({
      //     x: 20,
      //     y: 180
      //   })

      Row() {
        Text(this.date)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontSize(15)
          .fontColor("#ff8d8a8a")
          .layoutWeight(15)
        Image($r("app.media.comment"))
          .layoutWeight(1)
          .width(15)
        Blank()
          .layoutWeight(1)
        Text(this.num)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontColor("#ff8d8a8a")
          .fontSize(15)
          .layoutWeight(3)
      }
      .position({
        x: 10,
        y: 200
      })
    }
    .width('100%')
    .height(230)
  }
}