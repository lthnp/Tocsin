@extends('layouts.app')

@section('content')
    <div class="container">
        <div class="row overflow-auto">
            <div class="col mt-4 mb-4 float-left">
                <h2>
                    ID : {{$news->id}}
                    <a class="btn btn-red float-right" href="{{ route('newslists') }}">
                        <i class="fas fa-chevron-left"></i> ย้อนกลับ
                    </a>
                </h2>
            </div>
        </div>
        <div class="bg-white rounded shadow-sm">
            <div class="row">
                <div class="col position-relative p-5">
                    <h2 class="font-weight-bold">{{$news->title}}</h2>
                    <label class="p-0">
                        <a class="font-weight-bold text-dark" href="{{$news->link}}" target="_blank">{{$news->link}}</a>
                    </label><br>
                    <span class="text-black-50">{{$news->created_at}}</span>
                    <p class="text-warning mt-3 mb-5 font-weight-bold">Status : Editing</p>
                    @foreach($news->contents as $content)
                        @if($content == 'cannot find address')
                            <p class="text-font mt-5 text-red">{{$content}}</p>
                        @else
                            <p class="text-font mt-5">{{$content}}</p>
                        @endif
                    @endforeach
                    <div class="p-3"></div>
                    <div class="position-absolute pos-bottom-right">
                        <a href="{{ route('delnews', $news->id) }}" class="btn btn-outline-red"
                           onclick="return confirm('Confirm Delete News ID : ' + {{$news->id}} + ' ?');">
                            <i class="far fa-trash-alt"></i> Delete
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="card-body bg-white rounded shadow-sm mt-3 pb-3 position-relative">
            <h2 class="p-3 mb-4 font-weight-bold">
                Edit Location
                <span class="ml-3 mr-3" style="font-size: 20px">หรือ</span>
                @csrf
                <input type="text" name="news_id" value="{{$news->id}}" hidden>
                <a class="btn btn-outline-red m-auto" onclick="return confirm('ไม่พบข้อมูลที่อยู่เหตุอาชญากรรม?');" type="submit" href="javascript:history.back()">
                    <i class="fas fa-times pr-2"></i>ไม่พบที่อยู่
                </a>
            </h2>
            <form method="post" action="{{ route('storelocation') }}" class="bg-white row-cols-2 overflow-auto">
                @csrf
                <div class="col float-left">
                    <div class="form-group mb-4">
                        <p class="font-weight-bold">จังหวัด <span class="text-red">*</span></p>
                        <input id="province" class="form-control rounded-50" type="text" name="province" placeholder="กรอกจังหวัด">
                    </div>
                    <div class="form-group mb-4">
                        <p class="font-weight-bold">อำเภอ/เขต <span class="text-red">*</span></p>
                        <input id="amphoe" class="form-control rounded-50" type="text" name="amphur" placeholder="กรอกอำเภอ/เขต">
                    </div>
                    <div class="form-group mb-4">
                        <p class="font-weight-bold">กรอกตำบล/แขวง <span class="text-red">*</span></p>
                        <input id="district" class="form-control rounded-50" type="text" name="district" placeholder="กรอกตำบล/แขวง">
                    </div>
                    <div class="form-group mb-4">
                        <p class="font-weight-bold">รหัสไปรษณีย์ <span class="text-red">*</span></p>
                        <input id="zipcode" class="form-control rounded-50" type="text" name="zipcode" placeholder="กรอกรหัสไปรษณีย์" value="">
                    </div>
                    <div class="form-group mb-4">
                        <p class="font-weight-bold">รายละเอียดที่อยู่ <span class="text-red">*</span></p>
                        <textarea class="form-control rounded-nm" name="loc_details" cols="30" rows="5" placeholder="1-250 ตัวอักษร" maxlength="250"></textarea>
                    </div>
                </div>
                <div class="col float-left">
                    <div class="form-group mb-4">
                        <p class="font-weight-bold">หัวข้อเหตุอาชญากรรม <span class="text-red">*</span></p>
                        <input class="form-control rounded-50" type="text" name="news_title" placeholder="1-90 ตัวอักษร" maxlength="90">
                    </div>
                    <div class="form-group mb-4">
                        <p class="font-weight-bold">รายละเอียดอาชญากรรม <span class="text-red">*</span></p>
                        <textarea class="form-control rounded-nm" name="news_details" cols="30" rows="5" placeholder="1-250 ตัวอักษร" maxlength="250"></textarea>
                    </div>
                </div>
                <input type="text" name="news_id" value="{{$news->id}}" hidden>
                <div class="position-absolute pos-bottom-right pb-3">
                    <a class="btn btn-outline-red mt-3" href="javascript:history.back()">ยกเลิก</a>
                    <button class="btn btn-red mt-3" onclick="return confirm('ยืนยันข้อมูลที่อยู่เหตุอาชญากรรม?');" type="submit">ยืนยัน</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        $.Thailand({
            $district: $('#district'), // input ของตำบล
            $amphoe: $('#amphoe'), // input ของอำเภอ
            $province: $('#province'), // input ของจังหวัด
            $zipcode: $('#zipcode'), // input ของรหัสไปรษณีย์
        });
    </script>
@endsection
