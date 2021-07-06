@extends('layouts.app')

@section('content')
    <div class="container">
            <div class="pt-4 pb-4">
                <h2 class="font-weight-bold">
                    News Lists <span class="text-red" style="font-size: 16px;">ทั้งหมด {{count($locations)}} รายการ</span>
                </h2>
            </div>
            <div class="pb-4 overflow-hidden">
                <div class="pt-2 w-50 float-left" id="status-filter">
                    Filter >
                    <span style="color: #999">
                        <a href="{{ route('crimelocations') }}" class="filter filter-active" id="FT-All">All</a> |
                        <a href="{{ route('crimelocations') }}/?status=on" class="filter" id="FT-Proofed">ON</a> |
                        <a href="{{ route('crimelocations') }}/?status=off" class="filter" id="FT-Waiting">Off</a>
                    </span>
                </div>
                <div class="w-50 float-left">
{{--                    <form action="/" method="POST" role="search">--}}
{{--                        @csrf--}}
{{--                        <div class="input-group">--}}
{{--                            <input type="text" class="form-control" name="q" placeholder="Search users"> <span class="input-group-btn">--}}
{{--                                <button type="submit" class="btn btn-default">--}}
{{--                                    <i class="fas fa-search"></i>--}}
{{--                                </button>--}}
{{--                            </span>--}}
{{--                        </div>--}}
{{--                    </form>--}}
                    <input type="text" name="search_news" id="search" class="form-control rounded-50 w-50 float-right" placeholder="search for news">
                    <div class="pt-2 pr-4 float-right" id="status-filter" style="color: #999">
                        <a href="{{ route('crimelocations', ['status' => request('status'), 'sort' => 'asc']) }}" class="filter sort-active" id="asc">ก่อนหน้า</a> |
                        <a href="{{ route('crimelocations', ['status' => request('status'), 'sort' => 'desc']) }}" class="filter" id="desc">ล่าสุด</a>
                    </div>
                </div>
            </div>
            <div class="card-body bg-white rounded shadow-sm overflow-auto pr-5 pl-4" style="clear:both;">
            @if(count($locations) > 0)
                <div class="d-flex flex-row bd-highlight mb-3 w-100">
                    <div class="col-w-10">Status</div>
                    <div class="col-w-25 ml-3">Title</div>
                    <div class="col-w-40">Address</div>
                    <div class="col-w-20">Created_at</div>
{{--                    <div class="col-w-5">Action</div>--}}
                </div><hr>
                @foreach($locations as $location)
                    <div class="d-flex flex-row bd-highlight mb-3 pt-3 pb-3">
                        <div class="col-w-10 pr-4 text-break @if($location->status == "off") text-red @else text-success @endif pr-1 font-weight-bold">
                            <form method="post" action="{{route('switch-locationstatus', $location->id)}}">
                                @csrf
                                <div class="p-1 w-auto @if($location->status == "off") text-right @else text-left @endif" style="background: #e9e9e9; border-radius: 50px">
                                    <button id="switchbtn{{$location->id}}"
                                            type="submit"
                                            class="@if($location->status == "off") btn-secondary @else btn-success @endif font-weight-bold pl-2 pr-2"
                                            style="border-radius: 50px; border: none; outline: none;"
                                    >
                                        {{$location->status}}
                                    </button>
                                </div>
                            </form>
                        </div>
                        <a class="col-w-25 font-weight-bold text-dark text-decoration-none text-break text-dark ml-3" href="{{route('viewnews', $location->news_id)}}">{{$location->news_title}}</a>
                        <a class="col-w-40">
                            {{$location->loc_details.' '.$location->district.' '.$location->amphur.' '.$location->province.' '.$location->zipcode}}
                        </a>
                        <div class="col-w-20 text-break">{{$location->created_at}}</div>
{{--                        <div class="col-w-5">--}}
{{--                            <a href="{{ route('editbook', $location->id) }}" class="btn btn-outline-warning btn-rounded"><i class="far fa-edit"></i></a>--}}
{{--                            <a href="{{ route('notfoundlocation', $location->news_id) }}" class="btn btn-outline-red btn-rounded" onclick="return confirm('Confirm Delete Location : ' + {{$location->id}} + ' ?');">--}}
{{--                                <i class="far fa-trash-alt"></i>--}}
{{--                            </a>--}}
{{--                        </div>--}}
                    </div>
                @endforeach
            @else
                <div class="text-center p-4 m-auto">
                    <h1 class="font-weight-bold">ไม่พบข้อมูล</h1>
                </div>
            @endif
        </div>
    </div>


        <script>
            $(document).ready(function(){
                $("#switch{{$location->id}}").change(function (){
                    alert('clicked');
                    $( "#switchbtn{{$location->id}}" ).submit();
                    if(this.is(':checked')){
                    }
                });
            });

            var allFilter = document.getElementById("FT-All");
            var sort = document.getElementById("asc");

            @if(request('status') == '')
            var currentFilter = document.getElementById("FT-All");
            @elseif(request('status') == 'on')
            var currentFilter = document.getElementById("FT-Proofed");
            @elseif(request('status') == 'off')
            var currentFilter = document.getElementById("FT-Waiting");
            @endif

                allFilter.className = currentFilter.className.replace(" filter-active", "");
            currentFilter.className += " filter-active";


            @if(request('sort') == 'asc')
            var currentSort = document.getElementById("asc");

            @elseif(request('sort') == 'desc')
            var currentSort = document.getElementById("desc");

            @endif

                sort.className = currentSort.className.replace(" sort-active", "");
            currentSort.className += " sort-active";
        </script>
@endsection
