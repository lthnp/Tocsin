<?php

namespace App\Http\Controllers;

use App\Models\Location;
use App\Models\News;
use Illuminate\Http\Request;
use GuzzleHttp;
use GuzzleHttp\Client;

class LocationController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $locations = new Location();

        if(request()->has('status')){
            $locations = $locations->where('status', request('status'));
        }

        if (request()->has('sort')) {
            $locations = $locations->OrderBy('created_at', request('sort'));
        }

        $locations = $locations->get()->append([
            'status' => request('status'),
            'sort' => request('sort'),
        ]);

        return view('locationlists')->with('locations', $locations);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $this->validate($request, [
            'province'=>'required',
            'amphur'=>'required',
            'district'=>'required',
            'zipcode'=>'required',
            'loc_details'=>'required',
            'news_title'=>'required',
            'news_details'=>'required',
        ]);
        $loc_details = $request->input('loc_details');
        $province = $request->input('province');
        $amphur = $request->input('amphur');
        $district = $request->input('district');
        $zipcode = $request->input('zipcode');
        $address = $loc_details.$district.$amphur.$province.$zipcode;
        $client = new Client();
        $result =(string) $client->post('https://maps.google.com/maps/api/geocode/json?address='.urlencode($address).'&key=AIzaSyBK6U98a7IoynZjrOPz6Riwtfhhp-368GE')->getBody();
        $json = json_decode($result);
//        print ($address);
//        print ('https://maps.google.com/maps/api/geocode/json?address='.urlencode($address).'&key=AIzaSyD7HggFfsPVpS5prBfQxMpQFvnOhV4ggw0');
//        dd($json);

        $location = new Location();
        $location->loc_details = $loc_details;
        $location->province = $province;
        $location->amphur = $amphur;
        $location->district = $district;
        $location->zipcode = $zipcode;
        $location->lat = $json->results[0]->geometry->location->lat;
        $location->lng = $json->results[0]->geometry->location->lng;
        $location->news_title = $request->input('news_title');
        $location->news_details = $request->input('news_details');
        $location->news_id = $request->input('news_id');
        $location->status = 'on';
        $location->save();

        $news = News::find($request->input('news_id'));
        $news->status = 'Proofed';
        $news->save();

        return redirect('newsLists/'.$news->id)->with('success', 'Add Location Complete!');
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $location = Location::find($id);
        $news = News::find($location->news_id);

        return view('editlocation')
            ->with('news', $news)
            ->with('location', $location);

    }
    public function edit_notfound($id)
    {
        $news = News::find($id);
        return view('editlocation_notfound')->with('news', $news);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $location = Location::find($id);
        $news = News::find($location->news_id);

        $this->validate($request, [
            'province'=>'required',
            'amphur'=>'required',
            'district'=>'required',
            'zipcode'=>'required',
            'loc_details'=>'required',
            'news_title'=>'required',
            'news_details'=>'required',
        ]);
        $loc_details = $request->input('loc_details');
        $province = $request->input('province');
        $amphur = $request->input('amphur');
        $district = $request->input('district');
        $zipcode = $request->input('zipcode');
        $address = $loc_details.$district.$amphur.$province.$zipcode;

        $old_location = $location->loc_details.$location->district.$location->amphur.$location->province.$location->zipcode;

        if ($address != $old_location){
            $client = new Client();
            $result =(string) $client->post('https://maps.google.com/maps/api/geocode/json?address='.urlencode($address).'&key=AIzaSyBK6U98a7IoynZjrOPz6Riwtfhhp-368GE')->getBody();
            $json = json_decode($result);

            $location->loc_details = $loc_details;
            $location->province = $province;
            $location->amphur = $amphur;
            $location->district = $district;
            $location->zipcode = $zipcode;
            $location->lat = $json->results[0]->geometry->location->lat;
            $location->lng = $json->results[0]->geometry->location->lng;
        }

        $location->news_title = $request->input('news_title');
        $location->news_details = $request->input('news_details');

        $location->save();

        return redirect('newsLists/'.$news->id)->with('success', 'Edit Location Complete!');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $location = Location::find($id);
        $news = News::find($location->news_id);
        $location->delete();

        return redirect('newsLists/'.$news->id)->with('success', 'Edit Location Complete!');
    }

    public function switchStatus($id){
        $location = Location::find($id);


        if($location->status == 'on'){
            $location->status = 'off';
        } else {
            $location->status = 'on';
        }

        $location->save();

        return redirect()->route('crimelocations');
    }
}
