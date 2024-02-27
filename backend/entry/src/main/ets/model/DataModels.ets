

export class HealthInfo{
  id: number = 0;
  type: string = '';
  name: string='';
  image: Resource | null =null;
  value: number=0;

  constructor(id:number=0,type:string="111",name: string='',image:Resource|null=null) {
    this.id=id;
    this.type=type;
    this.name=name;
    this.image=image;
  }

}
