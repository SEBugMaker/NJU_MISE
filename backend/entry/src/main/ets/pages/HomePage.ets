import router from '@ohos.router'
import { BottomList } from '../view/BottomList'
import StyleListItem from '../view/StyleListItem'
import { userId, username } from './Login';
import http from '@ohos.net.http'
import AbilityLifecycleCallback from '@ohos.app.ability.AbilityLifecycleCallback';
import { CommonConstants, emailMap } from '../common/constants/CommonConstants';
import ItemData from '../common/bean/HomeItemData';
import mainViewModel from '../viewmodel/HomeViewModel';

/**
 * Personal Center page, displaying personal information and app-related settings.
 */
@Entry
@Component
struct HomePage {
  @State password: string = '';
  @State phoneNumber: string = '';
  @State email: string = '';
  @State gender: string = '';
  @State age: string = '';
  @State token: string = '';

  @Builder settingCell(item: ItemData) {
    Row() {
      Row({ space: 3 }) {
        Image(item.img)
          .width($r('app.float.setting_size'))
          .height($r('app.float.setting_size'))
        Text(item.title)
          .fontSize($r('app.float.normal_text_size'))
          .margin({ left: 15 })
      }

      Image($r('app.media.right_grey'))
        .width($r('app.float.setting_jump_width'))
        .height($r('app.float.setting_jump_height'))

    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width(CommonConstants.FULL_PARENT)
    .padding({
      left: $r('app.float.setting_settingCell_left'),
      right: $r('app.float.setting_settingCell_right')
    })
  }
  ListUrl2 = ['pages/MyPost', 'pages/PersonalMessage', '',
    '', '', '']

  aboutToAppear() {
    this.GetPersonalMessage()
  }

  build() {
    Column() {
      Column() {
        Text("我的")
          .fontWeight(FontWeight.Medium)
          .fontSize($r('app.float.page_title_text_size'))
          .margin({ top: $r('app.float.mainPage_tabTitles_margin'), left: 10 })
          .padding({ left: $r('app.float.mainPage_tabTitles_padding') })
      }
      .width(CommonConstants.FULL_PARENT)
      .alignItems(HorizontalAlign.Center)

      Row() {
        Image('https://bu.dusays.com/2023/12/23/658630e282ee9.jpg')
          .width(70)
          .height(70)
          .borderRadius(100)
        Column() {
          Text('' + username)
            .fontSize($r('app.float.setting_account_fontSize'))
            .fontColor(Color.Black)
          Text(this.email)
            .fontSize($r('app.float.little_text_size'))
            .margin({ top: $r('app.float.setting_name_margin') })
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: $r('app.float.setting_account_margin') })
      }
      .margin({ top: $r('app.float.setting_account_margin') })
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height($r('app.float.setting_account_height'))
      .backgroundColor(Color.White)
      .padding({ left: $r('app.float.setting_account_padding') })
      .borderRadius($r('app.float.setting_account_borderRadius'))


      List() {
        ForEach(mainViewModel.getSettingListData(), (item: ItemData, index) => {
          ListItem() {
            this.settingCell(item)
          }
          .height('62fp')
          .onClick(() => {
            // 点击更改选中的索引
            router.pushUrl({
              url: this.ListUrl2[index],
              // params:{
              //   username2:this.username
              // }
            });
          })
        }, (item: ItemData) => JSON.stringify(item))
      }
      .backgroundColor(Color.White)
      .width('100%')
      .height(CommonConstants.SET_LIST_WIDTH)
      .divider({
        // strokeWidth: $r('app.float.setting_list_strokeWidth'),
        strokeWidth: '1vp',
        color: Color.Gray,
        startMargin: $r('app.float.setting_list_startMargin'),
        endMargin: $r('app.float.setting_list_endMargin')
      })
      .borderRadius($r('app.float.setting_list_borderRadius'))
      .padding({ top: $r('app.float.setting_list_padding'), bottom: $r('app.float.setting_list_padding') })
      .margin({ top: 18 })

      Text('退出登录')
        .fontColor(Color.Red)
        .fontSize(20)
        .margin({ top: 50 })
        .decoration({
          type: TextDecorationType.Underline, color: Color.Red
        })
        .onClick(() => {
          AlertDialog.show({
            title: '退出登录',
            message: '是否确定退出登录？',
            autoCancel: false,
            alignment: DialogAlignment.Bottom,
            offset: { dx: 0, dy: -250 },
            primaryButton: {
              value: '取消',
              action: () => {

              }
            },
            secondaryButton: {
              value: '确定',
              fontColor: '#D94838',
              action: () => {

                router.pushUrl({
                  url: 'pages/Login',
                });
              }

            },
            cancel: () => {

            }
          })

        })

      Row() {
        BottomList({
          chosenIndex: 3
        })
      }.layoutWeight(2)

    }
    .backgroundColor("#F1F3F5")
  }

  GetPersonalMessage() {
    let httpRequest = http.createHttp();
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });

    httpRequest.request(
      "172.29.4.130:8888/account/getInfo",
      {
        header: {
          'Content-Type': 'application/json'
        },
        method: http.RequestMethod.POST,
        extraData: {
          "id": userId
        },
      }, (err, data) => {
      if (!err) {

        var temp = JSON.parse(data.result.toString());
        this.email = JSON.parse(data.result.toString()).data.email
        this.phoneNumber = JSON.parse(data.result.toString()).data.phoneNumber
        var ageNum: number = JSON.parse(data.result.toString()).data.age
        if (ageNum != null) {
          this.age = ageNum.toString()
        }
        this.gender = JSON.parse(data.result.toString()).data.gender
      } else {
        console.info('error:' + JSON.stringify(err));
        httpRequest.off('headersReceive');
        httpRequest.destroy();
      }
    }
    );
  }
}