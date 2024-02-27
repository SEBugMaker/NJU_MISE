import { CommonConstants } from "../common/constants/CommonConstants"
import mainViewModel from '../viewmodel/HealthViewModel';
import ItemData from '../common/bean/HealthItemData';
import { Zones } from '../view/ZonesComponent';
import http from '@ohos.net.http';
import { indexMap, titleList, titleMap, unitList } from '../pages/HealthDetail';
import { userId } from '../pages/Login';
import router from '@ohos.router';
import { BottomList } from '../view/BottomList';

//六个数据的最低值
//3.9～6.1毫摩尔/升 血糖
//60-100次/分钟 心率
//收缩压（高压）≥140 mmHg  ≤90 mmHg
//体重 身高 血压 血糖 心率 运动量
export let minValueList = [30, 140, 80, 3.0, 50, 0]


export let maxValueList = [120, 220, 160, 7.0, 120, 180]
//六个数据的差值
export let diffValueList = [90, 80, 80, 4.0, 70, 180]

export let colorList = ["#ffff1c00", "#fff3711a", "#c377d72a", "#ffff6504", "#ffff1c00"]
//体重 身高 血压 血糖 心率 运动量
export let colorProportion = [[0.1, 0.2, 0.4, 0.2, 0.1], [0.1, 0.1, 0.6, 0.1, 0.1],
  [0.1, 0.2, 0.5, 0.2, 0.1], [0.1, 0.2, 0.5, 0.2, 0.1],
  [0.15, 0.1, 0.4, 0.2, 0.15], [0.15, 0.25, 0.2, 0.25, 0.15]]

function delay(ms: number) {
  return new Promise(resolve => setTimeout(resolve, ms));
}


let title = ""
let ImageUrl = ""


@Entry
@Component
struct HealthManager {
  @State healthDataList: number[] = [-1, -1, -1, -1, -1, -1]
  @State healthTime: string[] = ["-1", " -1", " -1", " -1", "-1", "-1"]
  @State conclusion: string = ''
  @State content: string = ''
  @State getAI: boolean = false
  dialogController: CustomDialogController = new CustomDialogController({
    builder: article({
      ImageUrl: ImageUrl,
      title: title
    }),

    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    customStyle: true

  })

  async onPageShow() {
    for (var type of titleList) {
      let httpRequest = http.createHttp();
      httpRequest.on('headersReceive', (header) => {
        console.info('header: ' + JSON.stringify(header));
      });
      httpRequest.request(
        "172.29.4.130:8888/healthInfo/latest?type=" + titleMap.get(type) + "&userId=" + userId,
        {
          header: {
            'Content-Type': 'application/json'
          },
          method: http.RequestMethod.GET,
          connectTimeout: 6000,
          readTimeout: 6000,
        }, (err, data) => {
        if (!err) {

          if (JSON.parse(data.result.toString()).code == 1) {
            const parsedResponse = JSON.parse(data.result.toString());
            var temp: string = parsedResponse.data.records[0].data
            if (!isNaN(Number(temp))) {
              this.healthDataList[indexMap.get(parsedResponse.data.records[0].type)] = Number(temp)
              this.healthTime[indexMap.get(parsedResponse.data.records[0].type)] = parsedResponse.data.records[0].createTime
            }
          }
        } else {
          console.log("1test num wrong at " + indexMap.get(titleMap.get(type)).toString())
          console.info('error:' + JSON.stringify(err));
          httpRequest.off('headersReceive');
          httpRequest.destroy();
        }
      }
      );
    }
    await delay(200);
    this.content = getConclusion(this.healthDataList)
    this.getAiTips()
  }

  build() {
    Column() {
      Row() {
        Text("健康管理")
          .fontWeight(FontWeight.Medium)
          .fontSize($r('app.float.page_title_text_size'))
      }
      .width(CommonConstants.FULL_PARENT)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.White)
      .height('5%')
      Row() {

        Scroll() {
          Column({ space: CommonConstants.COMMON_SPACE }) {
            Row() {
              Text("  健康贴士")
                .fontSize(25)
                .fontColor(Color.Black)
                .fontWeight(FontWeight.Bold)
            }
            .margin({top:10})
            .width('100%')
            .justifyContent(FlexAlign.Start)
            Zones()


            Row() {
              Text("  健康详情")
                .fontSize(25)
                .fontColor(Color.Black)
                .fontWeight(FontWeight.Bold)
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            Grid() {
              ForEach(mainViewModel.getGridData(), (item: ItemData, index) => {
                GridItem() {
                  Column() {
                    Text(item.title)
                      .fontWeight(FontWeight.Bolder)
                      .fontSize(15)
                    if (this.healthDataList[index] == -1) {
                      Row() {
                        Text("暂无数据")
                          .fontWeight(FontWeight.Bolder)
                          .fontSize(20)
                      }
                    } else {
                      Row() {
                        Text(this.healthDataList[index].toString())
                          .fontWeight(FontWeight.Bolder)
                          .fontSize(30)
                        Text(" " + unitList[index])
                          .fontSize(15)
                          .fontColor(Color.Grey)
                          .offset({ y: 5 })
                      }
                    }

                    Column() {
                      if (index == 2 || index == 3) {
                        Line()
                          .width(50 - 2)
                          .height(3)
                          .backgroundColor('#ff0e0e0e')
                          .position({
                            x: 40 + 2,
                            y: 60 + 50
                          })
                          .rotate({
                            x: 0,
                            y: 0,
                            z: 1,
                            angle: (getAngle(minValueList, this.healthDataList, diffValueList, index) / 100) * 300 - 60,
                            // 0 -> 水平向左
                            centerX: '100%'
                          })
                        Gauge({
                          value: getAngle(minValueList, this.healthDataList, diffValueList, index),
                          min: 0,
                          max: 100
                        })
                          .startAngle(210)
                          .endAngle(150)
                          .colors([[colorList[0], colorProportion[index][0]], [colorList[1], colorProportion[index][1]],
                            [colorList[2], colorProportion[index][2]], [colorList[3], colorProportion[index][3]],
                            [colorList[4], colorProportion[index][4]]])
                          .strokeWidth(15)
                          .width(50 * 2)
                          .height(50 * 2)
                          .position({
                            x: 40,
                            y: 60
                          })
                      } else if (index == 0) {

                        Row() {
                          Image($r("app.media.weight"))
                            .height("55%")

                        }
                        .width("100%")
                        .justifyContent(FlexAlign.Center)
                        .offset({x:-8})
                      } else if (index == 1) {
                        Row() {
                          Image($r("app.media.height"))
                            .height("47%")
                        }
                        .width("100%")
                        .justifyContent(FlexAlign.Center)
                        .offset({x:-8})
                      } else if (index == 4) {
                        Row() {
                          Image($r("app.media.heart"))
                            .height("60%")
                        }
                        .width("100%")
                        .justifyContent(FlexAlign.Center)
                        .offset({x:-8})
                      } else if (index == 5) {
                        Row() {
                          Image($r("app.media.timer"))
                            .height("60%")
                        }
                        .width("100%")
                        .justifyContent(FlexAlign.Center)

                      }
                    }

                    Text(this.healthTime[index] == "-1" ? "" : this.healthTime[index].toString().substring(5, 10))
                      .position({ y: "90%", x: "5%" })
                      .fontColor(Color.Grey)
                      .fontSize(10)
                    Text(item.others)
                      .margin({ top: $r('app.float.home_list_margin') })
                      .fontSize($r('app.float.little_text_size'))

                    if (index != 0 && index != 1) {
                      if (this.healthDataList[index] == -1) {

                      }
                      else if (Number(this.healthDataList[index]) > minValueList[index] + diffValueList[index] * (1 - colorProportion[index][4]) && index != 5) {
                        Row() {
                          Image($r("app.media.err"))
                            .height("12%")
                          Blank()
                            .width(5)
                          Text("偏高")
                            .fontSize(20)
                            .fontWeight(FontWeight.Bold)
                        }
                        .position({ x: "60%", y: "5%" })
                      } else if (Number(this.healthDataList[index]) < minValueList[index] + diffValueList[index] * colorProportion[index][0]) {
                        Row() {
                          Image($r("app.media.err"))
                            .height("12%")
                          Blank()
                            .width(5)
                          Text("偏低")
                            .fontSize(20)
                            .fontWeight(FontWeight.Bold)
                        }
                        .position({ x: "60%", y: "5%" })
                      } else {
                        Image($r("app.media.normal"))
                          .height("15%")
                          .position({ x: "60%", y: "5%" })
                      }
                    }


                  }
                  .alignItems(HorizontalAlign.Start)

                }
                .padding({ top: $r('app.float.home_list_padding'), left: $r('app.float.home_list_padding') })
                .borderRadius($r('app.float.home_backgroundImage_borderRadius'))
                .align(Alignment.TopStart)
                .backgroundColor(Color.White)
                .backgroundImageSize(ImageSize.Cover)
                .width(CommonConstants.FULL_PARENT)
                .height(CommonConstants.FULL_PARENT)
                .onClick(() => {
                  router.pushUrl({
                    url: "pages/HealthDetail",
                    params: {
                      type: item.title,
                      content: getMes(this.healthDataList, item.title),
                      latestDate: this.healthDataList[index] == -1 ? "暂无数据" : this.healthDataList[index].toString() + unitList[index]
                    }
                  });
                })
              }, (secondItem: ItemData) => JSON.stringify(secondItem))
            }
            .width(CommonConstants.FULL_PARENT)
            .height("80%")
            .columnsTemplate('1fr 1fr')
            .rowsTemplate('1fr 1fr 1fr')
            .columnsGap($r('app.float.home_grid_columnsGap'))
            .rowsGap($r('app.float.home_grid_rowGap'))
            .margin({ bottom: 15 })
            .borderRadius(30)

            Row() {
              Text("  健康提要")
                .fontSize(25)
                .fontColor(Color.Black)
                .fontWeight(FontWeight.Bold)
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            Row() {
              if (this.getAI) {
                Text("  " + this.conclusion+"如遇身体不适，请以实际就医情况为主")
                  .fontSize(20)
                  .padding({ top: 5, left: 5, right: 5 })
              } else {
                Column() {
                  Text("请等待，你的健康概述生成中")
                    .fontColor(23)
                    .textAlign(TextAlign.Center)
                    .padding({ top: 5 })
                  Row() {
                    Image($r('app.media.loading'))
                      .height(50)
                      .width(50)
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.Center)
                }
                .height(70)
                .width('100%')
                .justifyContent(FlexAlign.Center)
              }

            }
            .padding({ bottom: 10 })
            .borderRadius(20)
            .backgroundColor('#FFFF')
            .width('100%')

            Row() {
              Text("  热门文章")
                .fontSize(25)
                .fontColor(Color.Black)
                .fontWeight(FontWeight.Bold)
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            Image($r("app.media.article1"))
              .width("100%")
              .margin({ bottom: 5 })
              .onClick(() => {
                title = "了解血糖"
                ImageUrl = "1"
                this.dialogController.open()
              })
            Image($r("app.media.article2"))
              .width("100%")
              .margin({ bottom: 5 })
              .onClick(() => {
                title = "了解听力损伤"
                ImageUrl = "2"
                this.dialogController.open()
              })
            Image($r("app.media.article3"))
              .width("100%")
              .margin({ bottom: 5 })
              .onClick(() => {
                title = "了解有氧适能"
                ImageUrl = "3"
                this.dialogController.open()
              })
            Image($r("app.media.article4"))
              .width("100%")
              .margin({ bottom: 5 })
              .onClick(() => {
                title = "洗手保护健康"
                ImageUrl = "4"
                this.dialogController.open()
              })
          }

        }
        .height('87.5%')
      }

      .backgroundColor("#ffefefef")

      Row() {
        BottomList({
          chosenIndex: 0
        })
      }.layoutWeight(1)
    }
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
          this.conclusion = JSON.parse(data.result.toString()).data
        }
        this.getAI = true
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

function getAngle(min: number[], data: number[], diff: number[], index: number): number {
  console.log("1test num: " + data[index].toString() + " min: " + min[index].toString() + " index: " + index.toString() + " test angle number: " + (100 * ((data[index] - min[index]) / diff[index])).toString())
  var temp = 100 * ((data[index] - min[index]) / diff[index])
  if (temp < 0) {
    temp = 0
  } else if (temp > 100) {
    temp = 100
  }
  return temp;
}

function getMes(data: number[], type: string): string {
  var res: string = "你好，你是一名优秀的专业的医生，营养师，以下是我的健康数据，请你对我的" + type + "给出一些健康建议。"
  let indexMap = new Map([
    ['体重', 0],
    ['身高', 1],
    ['血压', 2],
    ['血糖', 3],
    ['心率', 4],
    ['今日运动量', 5]
  ])
  let i = indexMap.get(type)
  if (data[i] != -1) {
    res += "我的" + titleList[i] + "是" + data[i] + unitList[i]
    //BMI
    if (i == 0 && data[1] != -1) {
      res += "," + "我的身高是" + data[1]
    }
    else if (i == 0) {
      res += "我还没有提供身高，请让我提供身高，结合BMI来分析"
    }

    if (i == 1 && data[0] != -1) {
      res += "," + "我的体重是" + data[0]
    }
    else if (i == 1) {
      res += "我还没有提供体重，请让我提供体重，结合BMI来分析"
    }
    //血压
    if (i == 2) {
      res += "我提供的是收缩压"
    }
  }
  else {
    res = "我目前的" + type + "还没有进行记录，请提醒我记录。"
  }
  return res += "请尽量简短，50-60字左右"
}

function getConclusion(data: number[]): string {
  var res: string = "你好，你是一名优秀的专业的医生，营养师，以下是我的健康数据，请你对我的健康情况给出一个概述，并提出改善建议，字数控制在50-60字"
  let indexMap = ['体重', '身高', '血压', '血糖', '心率', '今日运动量']
  let unitList = ['kg', 'cm', 'MmHg', 'Mmol/L', '/min', 'min']
  for (let i = 0;i < 6; i++) {
    if (data[i] != -1) {
      res += '我的' + indexMap[i] + "是" + data[i] + unitList[i]
    }
  }
  return res;
}

@CustomDialog
struct article {
  private controller?: CustomDialogController;
  @State ImageUrl: string = ""
  @State title: string = ""

  build() {
    Column() {
      Row() {
        Stack() {
          Text(this.title)
            .fontSize(20)
            .textAlign(TextAlign.Center)
            .width("100%")
          Text("完成")
            .fontColor("#e21b69ff")
            .onClick(() => {
              this.controller.close()
            })
            .width("100%")
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.End)
            .fontSize(20)
        }
      }
      .width("100%")
      .height("6.5%")
      .backgroundColor("#fff5f5f5")

      Scroll() {
        if (this.ImageUrl === "1") {
          Image($r("app.media.articleContent1"))
            .width("100%")
        } else if (this.ImageUrl === "2") {
          Image($r("app.media.articleContent2"))
            .width("100%")
        } else if (this.ImageUrl === "3") {
          Image($r("app.media.articleContent3"))
            .width("100%")
        } else if (this.ImageUrl === "4") {
          Image($r("app.media.articleContent4"))
            .width("100%")
        }
      }
      .height("93.5%")
    }
    .height("90%")
    .width('100%')
    .backgroundColor($r('app.color.white'))
  }
}
