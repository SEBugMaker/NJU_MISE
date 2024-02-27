import http from '@ohos.net.http'

import router from '@ohos.router';

var registerState: string = "注册成功";

@Entry
@Component
struct Register {
  @State error: Boolean = false
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
  usernameRep: RegExp = /^[a-z\d-_]*$/;
  @State username: string = ''
  emailRep: RegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+/;
  @State email: string = ''
  passwordRep: RegExp = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).*$/;
  @State password: string = ''
  confirmPasswordRep: RegExp = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).*$/;
  @State confirmPassword: string = '';
  phoneRep: RegExp = /^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\d{8}$/
  @State phone: string = ''
  ageRep: RegExp = /^(?:[1-9][0-9]?|1[01][0-9]|120)$/
  @State age: string = ''
  RepGroup: RegExp[] = [this.usernameRep,
  this.passwordRep,
  this.emailRep,
  this.phoneRep,
  this.ageRep]

  // @State paramGroup:string[] = [this.username,
  // this.password,this.email,this.phone,this.age]
  dialogController: CustomDialogController = new CustomDialogController({
    builder: RegisterCustomDialog({ content: registerState }),
  })

  build() {
    Column() {
      Image($r('app.media.back_icon'))
        .width(50)
        .height(50)
        .position({
          x: 0,
          y: 0
        })
        .onClick(()=>{
          router.pushUrl({
            url: 'pages/Login'
          });
        })

      Text("注册")
        .width('60%')
        .height(50)
        .fontSize(35)
        .position({
          x: '20%',
          y: 0
        })
        .textAlign(TextAlign.Center)
      Column() {
        Row() {
          Text("用户名:")
            .width('20%')
            .height(20)
            .fontSize(15)
            .textAlign(TextAlign.Center)
          TextInput({ text: this.content, placeholder: "请输入用户名" })
            .width('70%')
            .height(40)
            .border({ width: 1, color: '#ff050505', radius: 30, style: BorderStyle.Solid })
            .backgroundColor(Color.Transparent)
            .type(this.typeInput)
            .showPasswordIcon(false)
            .onEditChange((isEditing) => {
              this.isEditing = isEditing
              this.isFloatHint = this.isEditing || this.content !== ''
            })
            .onChange((value) => {
              this.username = value
              this.isFloatHint = this.isEditing || this.content !== ''
            })
          Text(this.placeholder)
            .enabled(false)
            .fontColor(this.isFloatHint ? '#ff2aa8fc' : '#ff888888')
            .position({ x: 0, y: this.isFloatHint ? 0 : '50%' })
            .translate({ x: 15, y: '-50%' })
            .animation({ duration: 100, curve: Curve.Linear })

        }
        .width('100%').height('10%')
        .position({
          y: '0%'
        })

        if (!this.usernameRep.test(this.username) && this.username) {
          Text('用户名只含小写字母数字和下划线')
            .width('100%')
            .height('5%')
            .fontSize(15)
            .fontColor('#fff81f1f')
            .textAlign(TextAlign.Center)
            .position({
              y: '12%'
            })
            .align(Alignment.Center)
            .translate({ y: '-50%' })
        }


        Row() {
          Text("密码:")
            .width('20%')
            .height(20)
            .fontSize(15)
            .textAlign(TextAlign.Center)
          TextInput({ text: this.content, placeholder: "请输入密码" })
            .width('70%')
            .height(40)
            .border({ width: 1, color: '#ff050505', radius: 30, style: BorderStyle.Solid })
            .backgroundColor(Color.Transparent)
            .type(InputType.Password)
            .showPasswordIcon(true)
            .onEditChange((isEditing) => {
              this.isEditing = isEditing
              this.isFloatHint = this.isEditing || this.content !== ''
            })
            .onChange((value) => {
              this.password = value
              this.isFloatHint = this.isEditing || this.content !== ''
            })
          Text(this.placeholder)
            .enabled(false)
            .fontColor(this.isFloatHint ? '#ff2aa8fc' : '#ff888888')
            .position({ x: 0, y: this.isFloatHint ? 0 : '50%' })
            .translate({ x: 15, y: '-50%' })
            .animation({ duration: 100, curve: Curve.Linear })


        }
        .width('100%')
        .height('10%')
        .position({
          y: '15%'
        })

        if (!this.passwordRep.test(this.password) && this.password) {
          Text('密码需包含大小写字母和数字')
            .width("100%")
            .height('5%')
            .fontSize(15)
            .fontColor('#fff81f1f')
            .textAlign(TextAlign.Center)

            .translate({ y: '-50%' })
            .position({
              y: '27%'
            })
        }


        Row() {
          Text("确认:")
            .width('20%')
            .height(80)
            .fontSize(15)
            .textAlign(TextAlign.Center)
          TextInput({ text: this.content, placeholder: "请确认密码" })
            .width('70%')
            .height(40)
            .border({ width: 1, color: '#ff050505', radius: 30, style: BorderStyle.Solid })
            .backgroundColor(Color.Transparent)
            .type(InputType.Password)
            .showPasswordIcon(true)
            .onEditChange((isEditing) => {
              this.isEditing = isEditing
              this.isFloatHint = this.isEditing || this.content !== ''
            })
            .onChange((value) => {
              this.confirmPassword = value
              this.isFloatHint = this.isEditing || this.content !== ''
            })
          Text(this.placeholder)
            .enabled(false)
            .fontColor(this.isFloatHint ? '#ff2aa8fc' : '#ff888888')
            .position({ x: 0, y: this.isFloatHint ? 0 : '50%' })
            .translate({ x: 15, y: '-50%' })
            .animation({ duration: 100, curve: Curve.Linear })

        }
        .width('100%')
        .height('10%')
        .position({
          y: '30%'
        })

        if (this.confirmPassword) {
          if (!(this.confirmPassword === this.password)) {
            Text('密码不一致')
              .width("100%")
              .height('5%')
              .fontSize(15)
              .fontColor('#fff81f1f')
              .textAlign(TextAlign.Center)
                // .border({ width: 1, radius: 15, color: '#ff2aa8fc' })
              .position({
                y: '42%'
              })
              .translate({ y: '-50%' })
          }
        }



        Row() {
          Text("邮箱:")
            .width('20%')
            .height(20)
            .fontSize(15)
            .textAlign(TextAlign.Center)
          TextInput({ text: this.content, placeholder: "请输入邮箱" })
            .width('70%')
            .height(40)
            .border({ width: 1, color: '#ff050505', radius: 30, style: BorderStyle.Solid })
            .backgroundColor(Color.Transparent)
            .type(this.typeInput)
            .showPasswordIcon(false)
            .onEditChange((isEditing) => {
              this.isEditing = isEditing
              this.isFloatHint = this.isEditing || this.content !== ''
            })
            .onChange((value) => {
              this.email = value
              this.isFloatHint = this.isEditing || this.content !== ''
            })
          Text(this.placeholder)
            .enabled(false)
            .fontColor(this.isFloatHint ? '#ff2aa8fc' : '#ff888888')
            .position({ x: 0, y: this.isFloatHint ? 0 : '50%' })
            .translate({ x: 15, y: '-50%' })
            .animation({ duration: 100, curve: Curve.Linear })

        }
        .width('100%')
        .height('10%')
        .position({
          y: '45%'
        })

        if (!this.emailRep.test(this.email) && this.email) {
          Text('邮箱格式错误')
            .width('100%')
            .height('5%')
            .fontSize(15)
            .fontColor('#fff81f1f')
            .textAlign(TextAlign.Center)

            .position({ y: '57%' })
            .translate({ y: '-50%' })
        }


        Row() {
          Text("电话:")
            .width('20%')
            .height(20)
            .fontSize(15)
            .textAlign(TextAlign.Center)
          TextInput({ text: this.content, placeholder: "请输入电话" })
            .width('70%')
            .height(40)

            .border({ width: 1, color: '#ff050505', radius: 30, style: BorderStyle.Solid })
            .backgroundColor(Color.Transparent)
            .type(this.typeInput)
            .showPasswordIcon(false)
            .onEditChange((isEditing) => {
              this.isEditing = isEditing
              this.isFloatHint = this.isEditing || this.content !== ''
            })
            .onChange((value) => {
              this.phone = value
              this.isFloatHint = this.isEditing || this.content !== ''
            })
          Text(this.placeholder)
            .enabled(false)
            .fontColor(this.isFloatHint ? '#ff2aa8fc' : '#ff888888')
            .position({ x: 0, y: this.isFloatHint ? 0 : '50%' })
            .translate({ x: 15, y: '-50%' })
            .animation({ duration: 100, curve: Curve.Linear })

        }
        .width('100%')
        .height('10%')
        .position({
          y: '60%'
        })

        if (!this.phoneRep.test(this.phone) && this.phone) {
          Text('电话格式错误')
            .width('100%')
            .height('5%')
            .fontSize(15)
            .fontColor('#fff81f1f')
            .textAlign(TextAlign.Center)

            .position({ y: '72%' })
            .translate({ y: '-50%' })
        }


        Row() {
          Text("年龄:")
            .width('20%')
            .height(20)
            .fontSize(15)
            .textAlign(TextAlign.Center)
          TextInput({ text: this.content, placeholder: "请输入年龄" })
            .width('70%')
            .height(40)
            .border({ width: 1, color: '#ff050505', radius: 30, style: BorderStyle.Solid })
            .backgroundColor(Color.Transparent)
            .type(this.typeInput)
            .showPasswordIcon(false)
            .onEditChange((isEditing) => {
              this.isEditing = isEditing
              this.isFloatHint = this.isEditing || this.content !== ''
            })
            .onChange((value) => {
              this.age = value
              this.isFloatHint = this.isEditing || this.content !== ''
            })
        }
        .width('100%')
        .height('10%')
        .position({
          y: '75%'
        })

        if (!this.ageRep.test(this.age) && this.age) {
          Text('年龄错误')
            .width('100%')
            .height('5%')
            .fontSize(15)
            .fontColor('#fff81f1f')
            .textAlign(TextAlign.Center)
              // .border({ width: 1, radius: 15, color: '#ff2aa8fc' })
            .position({ y: '87%' })
            .translate({ y: '-50%' })
        }

        Button("注册")
          .backgroundColor('#ff5a04b0')
          .width('50%')
          .height($r('app.float.login_btn_height'))
          .fontSize($r('app.float.text_input_font_size'))
          .fontWeight(100)
          .borderRadius($r('app.float.register_btn_border_radius'))
          .margin({ top: '12vp' })
          .position({
            x: '25%',
            y: '90%'
          })
          .align(Alignment.Center)
          .onClick(() => {
            var paramGroup: string[] = [this.username, this.password, this.email, this.phone, this.age];
            var result = judgeError(this.RepGroup, paramGroup)
            if (!result) {
              AlertDialog.show({
                message: '存在格式错误，请修改',
                autoCancel: true,
                alignment: DialogAlignment.Bottom,
                gridCount: 4,
                offset: { dx: 0, dy: -20 }
              })
            } else {
              let httpRequest = http.createHttp();
              httpRequest.on('headersReceive', (header) => {
                console.info('header: ' + JSON.stringify(header));
              });
              httpRequest.request(
                "172.29.4.130:8888/account/register",
                {
                  header: {
                    'Content-Type': 'application/json'
                  },
                  method: http.RequestMethod.POST,
                  extraData: {
                    "username": this.username,
                    "password": this.password,
                    "email": this.email,
                    "phoneNumber": this.phone,
                    "age": Number(this.age)
                  },
                  connectTimeout: 6000,
                  readTimeout: 6000,
                }, (err, data) => {
                if (!err) {
                  if (data.responseCode == 200) {
                    if (JSON.parse(data.result.toString()).code == 1) {
                      registerState = "注册成功"
                      this.dialogController.open()
                      router.pushUrl({
                        url: 'pages/Login'
                      });
                    }
                    else {
                      registerState = JSON.parse(data.result.toString()).msg

                      this.dialogController.open()
                    }
                  } else {
                    registerState = data.result.toString()
                    this.dialogController.open()
                  }

                } else {
                  registerState = "网络异常"
                  this.dialogController.open()
                  console.info('error:' + JSON.stringify(err));
                  httpRequest.off('headersReceive');
                  httpRequest.destroy();
                }
              }
              );
            }
          })

      }
      .width('90%')
      .height('70%')
      .backgroundColor('rgba(243, 243, 243, 0.6)')
      .backdropBlur(20)
      .borderRadius(10)
      .position({
        x: '5%',
        y: '14%'
      })
      .shadow({
        color: 'rgba(0, 0, 0, 0.12)',
        radius: 30,
        offsetX: 1,
        offsetY: 1,
      })
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.bac'))
  }
}

@CustomDialog
struct RegisterCustomDialog {
  @State content: string = "注册成功"
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