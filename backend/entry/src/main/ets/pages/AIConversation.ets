import router from '@ohos.router'
import { BottomList } from '../view/BottomList'
import { CommonConstants as Const } from '../common/constants/CommonConstants';

import UserQuestionItem from '../common/bean/UserQuestionItem';
import UserQuestionViewModel from '../viewmodel/UserQuestionViewModel';
import http from '@ohos.net.http';

/**
 * Personal Center page, displaying personal information and app-related settings.
 */
@Entry
@Component
struct AIConversation {
  @State QuestionList: UserQuestionItem[] = UserQuestionViewModel.getList();
  @State send: Boolean = false
  // 是否浮动提示
  @State isFloatHint: boolean = false
  // 输入的文本内容
  @State content: string = ''
  // 是否编辑状态
  isEditing = false
  // 占位符内容
  placeholder: string
  // 输入框类型
  typeInput: InputType = InputType.Normal

  build() {
    Column() {


      Column() {
        Text("AI问诊")
          .fontWeight(FontWeight.Medium)
          .fontSize($r('app.float.page_title_text_size'))
          .height('5%')
          .textAlign(TextAlign.Center)
        List() {
          ForEach(this.QuestionList, (item: UserQuestionItem, index?: number) => {
            ListItem() {
              if (item.question === true) {
                RightDialogBox({
                  text: item.content
                })
              } else {
                LeftDialogBox({
                  text: item.content
                })
              }

            }
          }, item => item)
        }
        .height('90%')
        .margin({top:25})
        Row() {
          TextInput({ text: this.content, placeholder: "请输入内容" })
            .width('86%')
            .height(80)
            .type(this.typeInput)
            .onEditChange((isEditing) => {
              this.isEditing = isEditing
              this.isFloatHint = this.isEditing || this.content !== ''
            })
            .backgroundColor('rgba(243, 243, 243, 0.6)')
            .onChange((value) => {
              this.content = value
              this.isFloatHint = this.isEditing || this.content !== ''
            })

          if (true) {
            Image($r("app.media.ssend"))
              .width(40)
              .height(40)
              // .fontSize(18)
              // .fontColor('#ff2aa8fc')
              // .textAlign(TextAlign.Center)
              .border({ width: 1, radius: 15, color: '#ff2aa8fc' })
              .position({ x: '87%', y: '60%' })
              .translate({ y: '-50%' })
              .onClick(() => {
                if (this.content === '') {
                  AlertDialog.show({
                    message: '输入不能为空',
                    autoCancel: true,
                    alignment: DialogAlignment.Center,
                    gridCount: 4,
                    offset: { dx: 0, dy: -20 }
                  })
                } else {
                  this.QuestionList = addNewQuestion(this.content, this.QuestionList)
                  console.log("content add: " + UserQuestionViewModel.getByIndex(this.QuestionList.length - 1).content)
                  console.log(this.QuestionList.length.toString())
                  //use API
                  this.QuestionList = addAnswer(this.content, this.QuestionList)
                  this.content = ''
                }
              })
          }
        }
        .border({ width: 3, color: '#2c5c07b1', radius: 10, style: BorderStyle.Solid })
        .width('100%').height('7%')
        .position({
          x: 0,
          y: '93%'
        })
      }
      .height('92.6%')
      .backgroundColor('rgba(243, 243, 243, 0.6)')
      .shadow({
        color: 'rgba(0, 0, 0, 0.12)',
        radius: 30,
        offsetX: 1,
        offsetY: 1,
      })
      .align(Alignment.Top)


      Row() {
        BottomList({
          chosenIndex: 1
        })
      }
      .backgroundColor('#FFFF')
      .layoutWeight(1)

    }
    .backgroundColor("#fff1f1f1")
    .height('100%')
    .width('100%')

  }
}

@Component
struct LeftDialogBox {
  private text: string

  build() {
    Row() {
      Image($r('app.media.AI_icon'))
        .width(40)
        .height(40)
        .borderRadius(30)
        .margin({ left: '10px', right: '10px' })
      Text(this.text)
        .fontSize('14fp')
        .backgroundColor("#ffffffff")
        .padding(10)
        .borderRadius(10)
        .margin({ right: '280px' })
    }
    .width('100%')
    .margin({ top: '20px', bottom: '20px' })
    .alignItems(VerticalAlign.Top)

  }
}


@Component
struct RightDialogBox {
  private text: string

  build() {
    Flex({ direction: FlexDirection.RowReverse }) {
      Image("https://bu.dusays.com/2023/12/23/658630e282ee9.jpg")
        .width(40)
        .height(40)
        .borderRadius(30)
        .margin({ left: '10px', right: '10px' })

      Flex({ direction: FlexDirection.RowReverse, justifyContent: FlexAlign.Start }) {
        Text(this.text)
          .fontSize('14fp')
          .backgroundColor("#1dde40")
          .padding(10)
          .borderRadius(10)
          .margin({ left: '140px' })
      }
    }.margin({ top: '20px', bottom: '20px' })
  }
}


function addNewQuestion(content: string, QuestionList: UserQuestionItem[]): UserQuestionItem[] {
  let old = QuestionList
  let newItem = new UserQuestionItem();
  newItem.id = old.length;
  newItem.content = content;
  newItem.question = true;
  QuestionList.push(newItem);
  return QuestionList;
}


function addAnswer(content: string, QuestionList: UserQuestionItem[]): UserQuestionItem[] {
  var temp: string;
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
        prompt: content
      },
      connectTimeout: 6000,
      readTimeout: 6000,
    }, (err, data) => {
    if (!err) {
      if (JSON.parse(data.result.toString()).code == 1) {
        console.log("result llm :" + JSON.parse(data.result.toString()).data)
        temp = JSON.parse(data.result.toString()).data
        let old = QuestionList
        let newItem = new UserQuestionItem();
        newItem.id = old.length;
        newItem.content = temp;
        newItem.question = false;
        QuestionList.push(newItem);
      } else {
        let old = QuestionList
        let newItem = new UserQuestionItem();
        newItem.id = old.length;
        newItem.content = '报歉，网络出错了';
        newItem.question = false;
        QuestionList.push(newItem);
      }
    } else {
      let old = QuestionList
      let newItem = new UserQuestionItem();
      newItem.id = old.length;
      newItem.content = '报歉，网络出错了';
      newItem.question = false;
      QuestionList.push(newItem);
    }
  }
  );
  return QuestionList;
}

