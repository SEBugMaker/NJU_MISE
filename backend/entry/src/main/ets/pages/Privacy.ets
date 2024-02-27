import router from '@ohos.router'
import http from '@ohos.net.http';
import { BottomList } from '../view/BottomList'
import { userId,username } from './Login';
import { PostContent } from './MedicalCommunity';


@Entry
@Component
struct Privacy{
  @State content :string = router.getParams()?.['content']
  @State title :string = router.getParams()?.['title']
  build() {
    Column() {
      Row(){
        Image($r("app.media.back_icon"))
          .onClick(() => {
            router.back()
          })
          .height(30)
          .width(30)
        Blank()
        Text(this.title)
          .textAlign(TextAlign.Center)
          .fontSize(25)
        Blank()
        }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height("5%")
      .backgroundColor('#ffe4e4e5')
      Scroll(){
        Text(this.content)
      }
      .align(Alignment.Top)
      .height("95%")

    }
  }

}