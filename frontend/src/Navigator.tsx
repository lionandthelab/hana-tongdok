import * as React from 'react';
interface IProps {
    name?: string;
}

const Navigator: React.FC<IProps> = (props: IProps) => 
    <div id="Navigator">
        <h1>This is Navigator</h1>
    </div>

Navigator.defaultProps = {
    name: 'world',
};

export default Navigator;
