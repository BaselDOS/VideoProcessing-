%video point tracker with box

videoFileReader=vision.VideoFileReader('visionface.avi');
videoPlayer=vision.VideoPlayer();

objectFrame=step(videoFileReader);
objectRegion=[265,122 ,93, 93];
bboxPoints=bbox2points(objectRegion(1,:));
bboxPolygon=reshape(bboxPoints',1,[]);

objectImage=insertShape(objectFrame,'Polygon',bboxPolygon,'Color','red');

figure;imshow(objectImage);

points=detectMinEigenFeatures(rgb2gray(objectFrame),'ROI',objectRegion);
xyPoints=points.Location;
oldPoints=xyPoints;

pointImage=insertMarker(objectFrame,points.Location,'+','Color','White');

figure;imshow(pointImage);

pointsTracker=vision.PointTracker('MaxBidirectionalError',1);
initialize(pointsTracker,points.Location,objectFrame);

while(~isDone(videoFileReader))
    frame=step(videoFileReader);
    [xyPoints,isFound]=step(pointsTracker,frame);
    visiblePoints=xyPoints(isFound,:);
    oldInliers=oldPoints(isFound,:);
    
    [xform,oldInliers,visiblePoints]=estimateGeometricTransform(...
        oldInliers,visiblePoints,'similarity','MaxDistance',4);
    bboxPoints=transformPointsForward(xform,bboxPoints);
    bboxPolygon=reshape(bboxPoints',1,[]);
    videoFrame=insertShape(frame,'Polygon',bboxPolygon,'LineWidth',3);
    videoFrame=insertMarker(videoFrame,visiblePoints,'+','Color','White');
    oldPoints=visiblePoints;
    setPoints(pointsTracker,oldPoints);
    step(videoPlayer,videoFrame);
end
release(videoPlayer);
release(videoFileReader);













