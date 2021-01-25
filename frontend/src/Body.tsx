import * as React from 'react';
interface IProps {
    name?: string;
}

const Body: React.FC<IProps> = (props: IProps) => 
    <div id="Body">
        <h1>This is Body</h1>
    </div>

Body.defaultProps = {
    name: 'world',
};

export default Body;
