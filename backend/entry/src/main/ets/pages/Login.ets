import router from '@ohos.router';
// 引入包名1
import http from '@ohos.net.http';
import FaultLogger from '@ohos.faultLogger';
var registerState :string = "注册成功";
export var username :string;
export var userId:BigInt;
@Entry
@Component
struct Login {
  @State chosen:boolean = false
  @State userName: string = '';
  @State password: string = '';
  @State token: string = '';
  dialogController: CustomDialogController = new CustomDialogController({
    builder: RegisterCustomDialog({content: registerState}),
  })
  build() {
    Column() {
      Column() {
        Image($r("app.media.doctoricon"))
          .height("16%")
          .margin(5)
        Text("Doctor67")
          .width('50%')
          .fontSize(20)
          .position({
            y:"18%",
            x:"25%"
          })
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .fontStyle(FontStyle.Italic)

        TextInput({ placeholder: $r('app.string.username') })
          .width('95%')
          .height($r('app.float.text_input_height'))
          .placeholderFont({ size: $r('app.float.text_input_font_size') })
          .backgroundColor('rgba(243, 243, 243, 0.6)')
          .backdropBlur(20)
          .borderRadius(10)
          .fontSize($r('app.float.text_input_font_size'))
          .onChange((value: string) => {
            this.userName = value;
          })
          .padding({ left: $r('app.float.password_padding_left') })
          .position({
            x: '2.5%',
            y: '30%'
          })



        TextInput({ placeholder: $r('app.string.password') })
          .width('95%')
          .height($r('app.float.text_input_height'))
          .placeholderFont({ size: $r('app.float.text_input_font_size') })
          .fontSize($r('app.float.text_input_font_size'))
          .backgroundColor('rgba(243, 243, 243, 0.6)')
          .backdropBlur(20)
          .borderRadius(10)
          .fontSize(18)
          .type(InputType.Password)
          .padding({ left: $r('app.float.password_padding_left') })
          .onChange((value: string) => {
            this.password = value;
          })
          .position({
            x: '2.5%',
            y: '45%'
          })

        Button($r('app.string.login'))
          .width('95%')
          .height('10%')
          .margin({ top: $r('app.float.login_btn_margin_top') })
          .borderRadius($r('app.float.login_btn_border_radius'))
          .fontSize($r('app.float.text_input_font_size'))
          .fontWeight(100)
          .enabled(isLoginButtonClickable(this.userName, this.password))
          .fontColor(isLoginButtonClickable(this.userName, this.password)
            ? Color.White
            : $r('app.color.grey'))
          .backgroundColor(isLoginButtonClickable(this.userName, this.password)
            ? '#ff5a04b0'
            : $r('app.color.black'))
          .onClick(
            () => {
              if(this.chosen){
                this.clickLogin(this.userName, this.password)
              }else {
                registerState="请先阅读用户协议和隐私条款"
                this.dialogController.open()
              }

            }
          )
          .position({
            x: '2.5%',
            y: '70%'
          })

        Button("注册")
          .width('95%')
          .height($r('app.float.login_btn_height'))
          .fontSize($r('app.float.text_input_font_size'))
          .fontWeight(100)
          .borderRadius($r('app.float.register_btn_border_radius'))
          .margin({ top: '12vp' })
          .fontColor(Color.White)
          .backgroundColor('#ff5a04b0')
          .onClick(() => {
            // 点击更改选中的索引
            router.pushUrl({
              url: 'pages/Register'
            });
          })
          .position({
            x: '2.5%',
            y:'85%'
          })

        Row(){
          Checkbox()
            .selectedColor('#ff5a04b0')
            .onChange(()=>{
              this.chosen = !this.chosen
            })
          Text("我已阅读并同意")
            .fontSize(13)
          Text("用户协议")
            .fontSize(13)
            .fontColor(Color.Blue)
            .onClick(()=>{
              router.pushUrl({
                url: 'pages/Privacy',
                params:{
                  title:"用户协议",
                  content:"一、协议内容\n本用户协议（以下简称“协议”）是用户（以下简称“用户”）与本公司（以下简称“我们”）之间关于使用我们提供的产品或服务（以下简称“服务”）的协议。本协议包括以下内容：\n服务条款：明确用户使用服务的条件和限制。\n隐私保护：详细说明我们如何收集、使用、储存和保护用户的个人信息。\n知识产权：明确用户在使用服务过程中所产生的内容的知识产权归属。\n法律适用和管辖：规定本协议的解释、争议解决的方式和适用的法律。\n二、服务条款\n用户应遵守本协议的规定，不得进行任何违反法律法规、侵犯他人权益的行为。\n用户应保证所提供的信息真实、准确、完整，并承担因提供虚假信息而产生的法律责任。\n用户应妥善保管自己的账号和密码，因用户自身原因导致的账号和密码泄露而产生的损失，我们不承担责任。\n我们保留在必要时修改服务条款的权利，用户应定期查阅并遵守最新的服务条款。\n三、隐私保护\n我们尊重用户的隐私权，并采取合理的技术和管理措施保护用户的个人信息。\n我们仅在法律允许的范围内收集和使用用户的个人信息，除非得到用户的同意或法律另有规定。\n未经用户同意，我们不会向任何第三方共享用户的个人信息，但以下情况除外：\na) 法律法规规定；\nb) 司法机关或行政机关依法要求；\nc) 维护社会公共利益和他人合法权益的必要。\n如果我们发现用户的个人信息有误或不全，我们将及时通知用户并协助其更正。\n四、知识产权\n用户在使用服务过程中所产生的内容（包括但不限于文字、图片、音频、视频等），均受相关法律法规的保护。\n未经用户或相关权利人的书面同意，我们不会将用户所产生的内容用于商业用途，也不会将其授权给第三方使用。\n如果用户发现任何侵犯知识产权或其他合法权益的内容，请及时向我们举报，我们将依法处理。\n五、法律适用和管辖\n本协议的签订、执行和解释均适用中华人民共和国的法律。\n因本协议引起的或与本协议有关的争议，双方应友好协商解决；协商不成的，任何一方均有权将争议提交至有管辖权的人民法院诉讼解决。"
                }
              });
            })
          Text("和")
            .fontSize(13)
          Text("隐私条款")
            .fontSize(13)
            .fontColor(Color.Blue)
            .onClick(()=>{
              router.pushUrl({
                url: 'pages/Privacy',
                params:{
                  content:"一、隐私政策\n我们深知个人信息对您的重要性，因此我们制定了本隐私政策，以明确我们对您的个人信息所负有的责任和义务。本隐私政策适用于我们所有的产品和服务，并适用于我们收集、使用、储存和共享您个人信息的方式。\n二、信息收集\n我们会收集您的个人信息，包括但不限于姓名、电子邮件地址、电话号码、住址等。这些信息可能来自于您使用我们的产品和服务的过程中，或者您主动提供给我们的信息。\n三、信息使用\n我们收集您的个人信息是为了提供更好的产品和服务，以及满足我们的合法需求。我们承诺仅在法律允许的范围内使用您的个人信息，并且不会将您的个人信息泄露给任何未经授权的第三方。\n四、信息储存和共享\n我们会采取适当的安全措施来保护您的个人信息，并保证这些信息仅用于我们指定的目的。除非得到您的同意或者法律规定，否则我们不会将您的个人信息共享给任何第三方。\n五、权利和义务\n您有权要求我们删除或更正您的个人信息，并有权了解我们如何使用您的个人信息。如果您发现我们的行为违反了本隐私政策，或者您有任何其他问题或疑虑，可以随时联系我们。\n六、修改和更新\n本隐私政策可能会根据法律要求、产品和服务的变化，或用户的反馈进行修改和更新。如有任何修改和更新，我们将及时公布。",
                  title:"隐私条款"
                }
              });
            })
        }
        .position({
          y:"60%"
        })
      }
      .width('80%')
      .height('50%')
      .backgroundColor('rgba(243, 243, 243, 0.6)')
      .backdropBlur(20)
      .borderRadius(10)
      .position({
        x: '10%',
        y: '25%'
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
  clickLogin(userName: string, password: string): void {
    let httpRequest = http.createHttp();
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(
      "172.29.4.130:8888/account/login",
      {
        header: {
          'Content-Type': 'application/json'
        },
        method: http.RequestMethod.POST,
        extraData: {
          "username": userName,
          "password": password,
        },
        connectTimeout: 6000,
        readTimeout: 6000,
      }, (err, data) => {
      if (!err) {
        if (data.responseCode == 200) {
          if(JSON.parse(data.result.toString()).code==1){
            username = userName

            const parsedResponse = JSON.parse(data.result.toString());

            userId = parsedResponse.data.id;
            router.pushUrl({
              url: 'pages/HomePage' ,
              params:{
                username:userName
              }
            })
          }
          else {
            registerState=JSON.parse(data.result.toString()).msg
            this.dialogController.open()
          }
        }else{
          registerState=data.result.toString()
          this.dialogController.open()
        }
      } else {
        registerState="网络异常"
        this.dialogController.open()
        console.info('error:' + JSON.stringify(err));
        httpRequest.off('headersReceive');
        httpRequest.destroy();
      }
    }
    );
  }
}


function isLoginButtonClickable(userName: string, password: string): boolean {
  return userName !== '' && password !== '';
}
@CustomDialog
struct RegisterCustomDialog {
  @State content:string = "注册成功"
  controller: CustomDialogController
  build() {
    Column() {
      Text(this.content)
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
    }
  }
}

