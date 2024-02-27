import router from '@ohos.router'
import http from '@ohos.net.http'
import { BottomList } from '../view/BottomList'
import { userId, username } from './Login';

var modifyState: string = "修改成功";

@Entry
@Component
struct PersonalMessage {
  usernameRep: RegExp = /^[a-z\d-_]*$/;
  emailRep: RegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+/;
  passwordRep: RegExp = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).*$/;
  phoneRep: RegExp = /^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\d{8}$/
  ageRep: RegExp = /^(?:[1-9][0-9]?|1[01][0-9]|120)$/
  RepGroup: RegExp[] = [this.emailRep, this.phoneRep, this.ageRep]

  @State password: string = '';
  @State phoneNumber: string = '';
  @State email: string = '';
  @State gender: string = '';
  @State age: string = '';
  @State token: string = '';
  dialogController: CustomDialogController = new CustomDialogController({
    builder: ModifyPersonalMessageDialog({ content: modifyState }),
  })

  aboutToAppear() {
    this.GetPersonalMessage()
  }

  build() {
    Column() {
      Text("个人信息")
        .fontSize(25)
        .height(50)
        .margin({ top: 20 })
      Row() {
        Text("用户名：" + username)
          .margin({ left: 20 })

      }.width('100%')
      .height('6%')

      Divider()
        .width('95%')
        .height($r('app.float.divider_height'))
        .color($r('app.color.grey'))
        .alignSelf(ItemAlign.Center)

      Row() {
        Text("电话：")
          .margin({ left: 20 })
        TextInput({ placeholder: this.phoneNumber })
          .type(InputType.Number)
          .width('95%')
          .height($r('app.float.text_input_height'))
          .placeholderFont({ size: $r('app.float.text_input_font_size') })
          .backgroundColor($r('app.color.white'))
          .fontSize($r('app.float.text_input_font_size'))
          .padding({ left: $r('app.float.username_padding_left') })
          .onChange((value: string) => {
            this.phoneNumber = value;
          })
        if (!this.phoneRep.test(this.phoneNumber) && this.phoneNumber) {
          Text('电话格式错误')
            .width(85)
            .height(20)
            .fontSize(9)
            .fontColor('#fff81f1f')
            .textAlign(TextAlign.Center)
              // .border({ width: 1, radius: 15, color: '#ff2aa8fc' })
            .position({ x: '78%', y: '50%' })
            .translate({ y: '-50%' })
        }
      }.height('6%')

      Divider()
        .width('95%')
        .height($r('app.float.divider_height'))
        .color($r('app.color.grey'))
        .alignSelf(ItemAlign.Center)
      Row() {
        Text("邮箱：")
          .margin({ left: 20 })
        TextInput({ placeholder: this.email })
          .type(InputType.Email)
          .width('95%')
          .height($r('app.float.text_input_height'))
          .placeholderFont({ size: $r('app.float.text_input_font_size') })
          .backgroundColor($r('app.color.white'))
          .fontSize($r('app.float.text_input_font_size'))
          .padding({ left: $r('app.float.username_padding_left') })
          .onChange((value: string) => {
            this.email = value;
          })
        if (!this.emailRep.test(this.email) && this.email) {
          Text('邮箱格式错误')
            .width(85)
            .height(20)
            .fontSize(9)
            .fontColor('#fff81f1f')
            .textAlign(TextAlign.Center)
              // .border({ width: 1, radius: 15, color: '#ff2aa8fc' })
            .position({ x: '78%', y: '50%' })
            .translate({ y: '-50%' })
        }
      }.height('6%')

      Divider()
        .width('95%')
        .height($r('app.float.divider_height'))
        .color($r('app.color.grey'))
        .alignSelf(ItemAlign.Center)
      Row() {
        Text("年龄：")
          .margin({ left: 20 })
        TextInput({ placeholder: this.age })
          .type(InputType.Email)
          .width('95%')
          .height($r('app.float.text_input_height'))
          .placeholderFont({ size: $r('app.float.text_input_font_size') })
          .backgroundColor($r('app.color.white'))
          .fontSize($r('app.float.text_input_font_size'))
          .padding({ left: $r('app.float.username_padding_left') })
          .onChange((value: string) => {
            this.age = value;
          })
        if (!this.ageRep.test(this.age) && this.age) {
          Text('年龄错误')
            .width(85)
            .height(20)
            .fontSize(9)
            .fontColor('#fff81f1f')
            .textAlign(TextAlign.Center)
              // .border({ width: 1, radius: 15, color: '#ff2aa8fc' })
            .position({ x: '78%', y: '50%' })
            .translate({ y: '-50%' })
        }
      }.height('6%')

      Divider()
        .width('95%')
        .height($r('app.float.divider_height'))
        .color($r('app.color.grey'))
        .alignSelf(ItemAlign.Center)
      Row() {
        Text("性别：")
          .margin({ left: 20 })
        Text('男')
        Radio({ value: '男', group: 'genderGroup' }).checked(this.gender == '男')
          .height('3%')
          .width('10%')
          .checked(this.gender==='男')
          .onChange((isChecked: boolean) => {
            if (isChecked) {
              this.gender = '男'
              console.log('Radio1 status is ' + this.gender)
            }
          })
        Text('女')
          .margin({ left: 20 })
        Radio({ value: '女', group: 'genderGroup' }).checked(this.gender == '女')
          .height('3%')
          .width('10%')
          .checked(this.gender==='女')
          .onChange((isChecked: boolean) => {
            if (isChecked) {
              this.gender = '女'
              console.log('Radio2 status is ' + this.gender)
            }

          })
        Text('未知')
          .margin({ left: 20 })
        Radio({ value: '未知', group: 'genderGroup' }).checked(this.gender == '')
          .height('3%')
          .width('10%')
          .checked(this.gender===null)
          .onChange((isChecked: boolean) => {
            if (isChecked) {
              this.gender = ''
              console.log('Radio3 status is ' + this.gender)
            }
          })

      }.width('100%')

      Divider()
        .width('95%')
        .height($r('app.float.divider_height'))
        .color($r('app.color.grey'))
        .alignSelf(ItemAlign.Center)

      Row() {
        Button("取消")
          .width('45%')
          .height($r('app.float.login_btn_height'))
          .fontSize($r('app.float.text_input_font_size'))
          .fontWeight(100)
          .borderRadius($r('app.float.register_btn_border_radius'))
          .backgroundColor('#ff5a04b0')
          .margin({ top: '12vp', left: 5 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/HomePage',
            });
          })
        Blank().width(5)
        Button("确定")
          .width('45%')
          .height($r('app.float.login_btn_height'))
          .fontSize($r('app.float.text_input_font_size'))
          .fontWeight(100)
          .borderRadius($r('app.float.register_btn_border_radius'))
          .backgroundColor('#ff5a04b0')
          .margin({ top: '12vp' })
          .onClick(() => {
            var paramGroup: string[] = [this.email, this.phoneNumber, this.age];
            var result = judgeError(this.RepGroup, paramGroup);
            if(result){
              let httpRequest = http.createHttp();
              httpRequest.on('headersReceive', (header) => {
                console.info('header: ' + JSON.stringify(header));
              });
              httpRequest.request(
                "172.29.4.130:8888/account/updateInfo",
                {
                  header: {
                    'Content-Type': 'application/json'
                  },
                  method: http.RequestMethod.POST,
                  extraData: {
                    "id": userId,
                    "username": username,
                    "phoneNumber": this.phoneNumber,
                    "email": this.email,
                    "avatar": null,
                    "status": 1,
                    "gender": this.gender,
                    "intro": "hello",
                    "age": this.age
                  },
                  connectTimeout: 6000,
                  readTimeout: 6000,
                }, (err, data) => {
                if (!err) {
                  console.log("sunguyi: " + userId)
                  console.log("sunguyi* " + userId.valueOf())
                  if (data.responseCode == 200) {
                    modifyState = JSON.parse(data.result.toString()).msg
                    this.dialogController.open()
                  } else {
                    modifyState = JSON.parse(data.result.toString()).msg
                    this.dialogController.open()
                  }

                } else {
                  console.info('error:' + JSON.stringify(err));
                  httpRequest.off('headersReceive');
                  httpRequest.destroy();
                }
              }
              );
            }else{
              AlertDialog.show({
                message: '存在格式错误，请修改',
                autoCancel: true,
                alignment: DialogAlignment.Bottom,
                gridCount: 4,
                offset: { dx: 0, dy: -20 }
              })
            }

          })
      }

      Row() {
        BottomList({
          chosenIndex: 3
        })
      }.layoutWeight(2)
    }
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

@CustomDialog
struct ModifyPersonalMessageDialog {
  @State content: string = "修改成功"
  controller: CustomDialogController

  build() {
    Column() {
      Text(this.content)
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
    }
  }
}

function judgeError(list: RegExp[], str: string[]): Boolean {
  var temp = true;
  for (var i = 0; i < list.length; i++) {
    if (list[i].test(str[i])) {
      console.log("no error")
    } else {
      console.log("error")
      temp = false;
    }
  }
  return temp;
}