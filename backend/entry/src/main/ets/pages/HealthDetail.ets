import router from '@ohos.router'
import http from '@ohos.net.http';
import { userId, username } from './Login';
import image from '@ohos.multimedia.image';
import { colorProportion, diffValueList, minValueList } from './HealthManager';


export class HealthInfoContent {
  id: string
  userId: string
  userName: string
  type: string
  data: string
  createTime: string

  constructor(userId: string, userName: string, type: string, data: string, createTime: string, id: string) {
    this.userId = userId
    this.userName = userName
    this.type = type
    this.data = data
    this.createTime = createTime
    this.id = id
  }
}

export let titleList = ['体重', '身高', '血压', '血糖', '心率', '今日运动量']

export let unitList = ['kg', 'cm', 'MmHg', 'Mmol/L', '/min', 'min']

//六个数据的最低值
//3.9～6.1毫摩尔/升 血糖
//60-100次/分钟 心率
//收缩压（高压）≥140 mmHg  ≤90 mmHg

export let titleMap = new Map([
  ['体重', 'weight'],
  ['身高', 'height'],
  ['血压', 'blood_pressure'],
  ['血糖', 'blood_sugar'],
  ['心率', 'heart_rate'],
  ['今日运动量', 'exercise']
])

export let indexMap = new Map([
  ['weight', 0],
  ['height', 1],
  ['blood_pressure', 2],
  ['blood_sugar', 3],
  ['heart_rate', 4],
  ['exercise', 5]
])

let mul = [300, 100, 170, 3000, 200, 200]

export let reverseTitleMap = new Map([
  ['weight', '体重'],
  ['height', '身高'],
  ['blood_pressure', '血压'],
  ['blood_sugar', '血糖'],
  ['heart_rate', '心率'],
  ['exercise', '今日运动量']
])

export let unitMap = new Map([
  ['weight', 'kg'],
  ['height', 'cm'],
  ['blood_pressure', 'MmHg'],
  ['blood_sugar', 'Mmol/L'],
  ['heart_rate', '/min'],
  ['exercise', 'min']
])

let tempInfo: HealthInfoContent

@Entry
@Component
struct HealthDetail {
  @State recordList: HealthInfoContent[] = []
  @State type: string = titleMap.has(router.getParams()?.['type']) ? titleMap.get(router.getParams()?.['type']) : router.getParams()?.['type'];
  @State content: string = router.getParams()?.['content']
  @State tip: string = "获取AI提示中，请稍候"
  @State aiTip: boolean = true
  @State latestDate: string = "-1"
  dialogController: CustomDialogController = new CustomDialogController({
    builder: RecordDialog({
      content: this.content,
      type: $type
    }),
    autoCancel: true,
    alignment: DialogAlignment.Default,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })
  confirmController: CustomDialogController = new CustomDialogController({
    builder: Confirm({
      content: this.content,
      info: tempInfo
    }),
    autoCancel: true,
    alignment: DialogAlignment.Default,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })

  onPageShow() {
    this.GetHealthDetail(userId, this.type)
    this.getAiTips()
  }

  build() {

    Column() {
      PageTitle({ type: reverseTitleMap.get(this.type) })
      //HealthImageDisplay()

      Stack({ alignContent: Alignment.Bottom }) {


        Column() {
          ForEach([1, 0, 0, 0, 0, 1], (item: number) => {
            if (item != 1) {
              Divider()
                .strokeWidth(1)
                .color('#75c6c2c2')

            } else {
              Divider()
                .strokeWidth(1)
                .color('rgba(255, 255, 255, 0.60)')
            }

          })
        }
        .height('100%')
        // .margin({ top: 20 })
        .justifyContent(FlexAlign.SpaceBetween)


        List() {
          ForEach(this.recordList, (item: HealthInfoContent) => {
            ListItem() {
              Column() {
                if (Number(item.data) > 0) {
                  Rect({ width: 14, height: Number(item.data) * mul[indexMap.get(this.type)] / 200 + 14, radius: 7 })
                    .fill('#FD9A42')
                  Row() {
                    Text(item.data)
                    Text(unitMap.get(item.type))
                      .fontSize(10)
                      .fontColor(Color.Grey)
                  }

                  Text(item.createTime)
                    .fontSize(10)
                    .fontColor(Color.Grey)
                }
              }
              .justifyContent(FlexAlign.End)
              .height('100%')
              .gesture(
                LongPressGesture({ repeat: false })
                  // 长按动作一结束触发
                  .onAction(() => {
                    tempInfo = item
                    this.confirmController.open()
                  })
              )
            }
            .width(60)

          })
        }
        .scrollBar(BarState.On)
        .listDirection(Axis.Horizontal)
        .width('100%')
        .offset({ y: -15 })

        // Text("历史记录")
        //   .fontSize(24)
        //   .textAlign(TextAlign.Center)
      }
      .height('35%')
      .width('100%')
      .backgroundColor('rgba(255, 255, 255, 0.60)')
      .borderStyle(BorderStyle.Dotted)
      .margin({ top: 10 })

      Stack() {
        if (this.latestDate !== "-1") {
          Row() {
            Column() {
              Text("当前" + reverseTitleMap.get(this.type))
                .fontSize(15)
              Text(this.latestDate + unitList[indexMap.get(this.type)])
                .fontSize(20)
            }


            Blank()
              .width(90)
            if (Number(this.latestDate) > minValueList[indexMap.get(this.type)] + diffValueList[indexMap.get(this.type)] * (1 - colorProportion[indexMap.get(this.type)][4])) {
              Row() {
                Image($r("app.media.err"))
                  .height("30%")
                Blank()
                  .width(10)
                Text("偏高")
                  .fontSize(30)
                  .fontWeight(FontWeight.Bold)
              }
            } else if (Number(this.latestDate) < minValueList[indexMap.get(this.type)] + diffValueList[indexMap.get(this.type)] * colorProportion[indexMap.get(this.type)][0]) {
              Row() {
                Image($r("app.media.err"))
                  .height("30%")
                Blank()
                  .width(10)
                Text("偏低")
                  .fontSize(30)
                  .fontWeight(FontWeight.Bold)
              }
            } else {
              Image($r("app.media.normal"))
                .height("50%")
            }

          }
          .justifyContent(FlexAlign.SpaceBetween)
        } else {
          Row() {
            Column() {
              Text("当前还没有记录数据，请先记录一下吧！")
                .fontSize(13)
            }
          }
          .justifyContent(FlexAlign.SpaceBetween)
        }

      }
      .backgroundColor('#ffffffff')
      .height("10%")
      .width("100%")
      .margin({ top: 15 })

      Stack() {
        // Image($r("app.media.background_img_6"))
        // .width('100%')
        // .height('100%')
        // .objectFit(ImageFit.Cover)
        Column() {
          Row() {
            Image($r("app.media.tips"))
              .height("20%")
            Text("AI小贴士")
              .textAlign(TextAlign.Center)
              .fontSize(20)
              .height("20%")

          }


          if (this.aiTip) {
            Image($r('app.media.loading'))
              .width(100)
              .height(100)
              .margin({ top: 0 })
              .onClick(() => {
                this.getAiTips()
              })
            Text("加载中...")
              .fontSize(15)
          } else {
            List() {
              ListItem() {
                Text(this.tip)
                  .textAlign(TextAlign.Start)
                  .onClick(() => {
                    this.getAiTips()
                  })
              }
            }
            .scrollBar(BarState.Auto)
            .margin({ right: 10, left: 10 })
          }
        }
        .width('100%')
        .height(150)
      }
      .margin({ top: 20, bottom: 500 })
      .backgroundColor('#ffffffff')


      Button("记录", { type: ButtonType.Capsule, stateEffect: true })
        .backgroundColor('#ff7e10cb')
        .height(42)
        .width('80%')
        .margin({ top: 32, bottom: 32 })
        .position({ x: '10%', y: '85%' })
        .onClick(() => {
          if (this.dialogController != undefined) {
            this.dialogController.open()
          } else {
            console.log("error")
          }
        })
    }
    .backgroundColor("#d8f1f0f0")
  }
  // 健康信息分页查询
  GetHealthDetail(userId: BigInt, type: string) {
    let httpRequest = http.createHttp();
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(
      "172.29.4.130:8888/healthInfo/page?page=1&pageSize=10&type=" + type + "&userId=" + userId,
      {
        header: {
          'Content-Type': 'application/json'
        },
        method: http.RequestMethod.GET,
        connectTimeout: 6000,
        readTimeout: 6000,
      }, (err, data) => {
      if (!err) {
        if (JSON.parse(data.result.toString()).code) {
          const parsedResponse = JSON.parse(data.result.toString());
          var Health: HealthInfoContent[] = []
          for (let i = 0; i < (parsedResponse.data.total > parsedResponse.data.size ? parsedResponse.data.size : parsedResponse.data.total); i++) {
            Health.push(new HealthInfoContent(parsedResponse.data.records[i].userId, parsedResponse.data.records[i].username
              , parsedResponse.data.records[i].type,
              parsedResponse.data.records[i].data, parsedResponse.data.records[i].createTime, parsedResponse.data.records[i].id))
            if (i == (parsedResponse.data.total > parsedResponse.data.size ? parsedResponse.data.size : parsedResponse.data.total) - 1) {
              this.latestDate = parsedResponse.data.records[i].data;
            }

          }
          this.recordList = Health
        }
      } else {
        console.info('error:' + JSON.stringify(err));
        httpRequest.off('headersReceive');
        httpRequest.destroy();
      }
    }
    );

  }

  getAiTips() {

    let httpRequest = http.createHttp();
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });

    httpRequest.request(
      "172.29.4.130:8888/llm/chat",
      {
        header: {
          'Content-Type': 'application/json'
        },
        method: http.RequestMethod.POST,
        extraData: {
          prompt: this.content
        },
      }, (err, data) => {
      if (!err) {
        if (JSON.parse(data.result.toString()).code == 1) {
          this.tip = JSON.parse(data.result.toString()).data
        }
        this.aiTip = false
        console.log("AI Tips Loading Finished")

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
struct RecordDialog {
  content: string = ""
  @State recordValue: string = ''
  recordRep: RegExp = /^-?\d+(\.\d+)?$/
  RepGroup: RegExp[] = [this.recordRep]
  @Link type: string
  controller: CustomDialogController
  unit: string = unitMap.get(this.type)

  build() {
    Column() {
      Text().fontSize(20).margin({ top: 10, bottom: 10 })
      TextInput({ placeholder: '请输入数值，单位:' + this.unit }).height(60).width('90%')
        .onChange((value: string) => {
          this.recordValue = value
        })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button("取消")
          .onClick(() => {
            this.controller.close()

          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button("记录")

          .onClick(() => {
            if (!this.recordRep.test(this.recordValue) || this.recordValue == null) {
              AlertDialog.show({
                message: '请输入合法信息',
                autoCancel: true,
                alignment: DialogAlignment.Center,
                gridCount: 4,
                offset: { dx: 0, dy: -20 }
              })
            } else {
              AddHealthDetail(userId, this.type, this.recordValue, username, this.content + "我的最新" + reverseTitleMap.get(this.type) + "数据已经从之前告诉你的变成了现在的" + this.recordValue + unitList[indexMap.get(this.type)] + ",请结合我的变化为我分析我的健康状况")
              this.controller.close()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
      }.margin({ bottom: 10 })
    }
  }
}


@Component
struct PageTitle {
  type?: string;
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({

    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })

  build() {
    Stack() {
      Row(){
        Image($r('app.media.ic_back'))
          .width(40)
          .height(40)
          .onClick(() => {
            router.pushUrl({
              url: "pages/HealthManager"
            })
          })
        Image($r("app.media.alert_circle_tips"))
        .height(40)
        .width(40)
        .onClick(() => {
          this.dialogController.open()
        })
      }
      .width("100%")
      .justifyContent(FlexAlign.SpaceBetween)
      Text(this.type)
        .fontSize(25)
    }
    .padding(12)
    .width('100%')
  }
}
// 发布健康信息
function AddHealthDetail(userId: BigInt, type: string, data: string, username: string, content: string) {
  let httpRequest = http.createHttp();
  httpRequest.on('headersReceive', (header) => {
    console.info('header: ' + JSON.stringify(header));
  });

  httpRequest.request(
    "172.29.4.130:8888/healthInfo/add",
    {
      header: {
        'Content-Type': 'application/json'
      },
      method: http.RequestMethod.POST,
      extraData: {
        "userId": userId,
        "type": type,
        "data": data,
        "username": username
      },
      connectTimeout: 6000,
      readTimeout: 6000,
    }, (err, data) => {
    if (!err) {
      console.log("HealthInfo:" + JSON.parse(data.result.toString()).data)
      router.pushUrl({
        url: "pages/HealthDetail",
        params: {
          type: type,
          content: content
        }
      })
      console.log(JSON.parse(data.result.toString()).msg)
    } else {
      console.info('error:' + JSON.stringify(err));
      httpRequest.off('headersReceive');
      httpRequest.destroy();
    }
  }
  );
}

@CustomDialog
struct Confirm {
  content: string
  controller: CustomDialogController
  @State info: HealthInfoContent = new HealthInfoContent("", "", "", "", "", "")

  build() {
    Column() {
      Text("确认删除这条记录吗?")
        .fontSize(20)
        .margin({
          top: 20
        })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button("取消")
          .onClick(() => {

            this.controller.close()
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button("删除")
          .onClick(() => {
            DeleteHealthDetail(this.info.type, this.content, this.info.id)
            this.controller.close()
          }).backgroundColor("0xffffff").fontColor(Color.Red)
      }
      .margin({
        top: 10,
        bottom: 10
      })
    }
  }
}

function DeleteHealthDetail(type: string, content: string, id: string) {
  let httpRequest = http.createHttp();
  httpRequest.on('headersReceive', (header) => {
    console.info('header: ' + JSON.stringify(header));
  });
  httpRequest.request(
    "172.29.4.130:8888/healthInfo/delete?id=" + id,
    {
      header: {
        'Content-Type': 'application/json'
      },
      method: http.RequestMethod.DELETE,
    }, (err, data) => {
    if (!err) {
      console.log(JSON.parse(data.result.toString()).msg + "asd")
      if (JSON.parse(data.result.toString()).code) {
        router.pushUrl({
          url: "pages/HealthDetail",
          params: {
            type: type,
            content: content
          }
        })
      }
    } else {
      console.info('error:' + JSON.stringify(err));
      httpRequest.off('headersReceive');
      httpRequest.destroy();
    }
  }
  );

}

@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController

  build() {
    Column() {
      Text('使用指南')
        .fontSize(30)
      Text('\n  doctor67是一款基于人工智能的个人健康管理软件，让我们快速开始使用吧。\n  1. 记录自己的第一条数据：点击记录按钮，输入对应的数值，就可以看到数据的可视化图标。\n  2. AI提示：我们会根据记录的数据通过AI分析给出最佳且精炼的分析，当然身体不适时请前往医院就医。\n  3. 输错了怎么办呢？doctor67提供简单的删除方法，只要长按错误的数据即可快速删除。\n  现在让我们开始体验健康之旅吧')
        .fontSize(20)
        .textAlign(TextAlign.Start)
    }
    .height(500)
    .width('100%')
    .borderRadius(20)
    .backgroundColor('#FFFF')
  }
}