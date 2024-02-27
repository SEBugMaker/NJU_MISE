import url from '@ohos.url'
import router from '@ohos.router'
@Component
export struct BottomList {
  @State chosenIndex :number = -1
  listItem = ['健康管理', 'ai问诊',  '社区', '我的']
  ListUrl = ['pages/HealthManager', 'pages/AIConversation',
    'pages/MedicalCommunity', 'pages/HomePage']
  ImgUrl = [$r('app.media.manager'),$r('app.media.chat'),$r('app.media.community'),$r('app.media.mine')]


  build() {
    Column() {
      Row() {
        ForEach(this.listItem, (item, index) => {
          Column() {
            Image((this.ImgUrl[index]))
              .width(30).height(30)
              .margin({ top: 10})
            Text(item)
              .fontSize(12)
              .fontColor(index == this.chosenIndex? "#ffffffff":'#ff000000')
          }
          .enabled(index != this.chosenIndex)
          .backgroundColor( index == this.chosenIndex? "#ff5b07d0":'#ffc8c8d6')
          .width('25%')
          .height('100%')
          .onClick(() => {
            // 点击更改选中的索引
            router.pushUrl({
              url: this.ListUrl[index]
            });
          })
        }, item => item)
      }
      .width('100%')
      .height(60)
      .backgroundColor('#ffccccd0')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.End)
  }
}